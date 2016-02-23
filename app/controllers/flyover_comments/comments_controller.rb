require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class CommentsController < ApplicationController
    include FlyoverComments::Authorization
    include FlyoverComments::Concerns::CommentFiltering
    include FlyoverComments::Concerns::CommentAlerts

    respond_to :json, only: [:create, :update, :index]
    respond_to :html, only: [:create, :show]
    respond_to :js, only: [:destroy, :show, :update]

    def index
      load_filtered_comments_list
      authorize_flyover_comment_index!

      respond_with @comments do |format|
        format.html{
          render partial: "flyover_comments/comments/comments", locals: { commentable: commentable, comments: @comments }
        }
      end
    end

    def create
      @comment = FlyoverComments::Comment.new(comment_params)
      @comment._user = _flyover_comments_current_user
      @comment.commentable = commentable
      @comment.parent = parent
      authorize_flyover_comment_creation!

      flash_key = @comment.save ? :success : :error
      process_comment_creation(@comment) if @comment.persisted?
      respond_with @comment do |format|
        format.html{ redirect_to :back, :flash => { flash_key => t("flyover_comments.comments.flash.create.#{flash_key.to_s}") } }
        format.json{
          if @comment.errors.any?
            render json: { errors: @comment.errors }, status: :unprocessable_entity
          else
            render partial: "flyover_comments/comments/comment", locals: { comment: @comment }
          end
        }
      end
    end

    def show
      @comment = FlyoverComments::Comment.find(params[:id])
      @top_level_comment = @comment.parent || @comment
      @children = @comment.children.page(params[:page])

      authorize_flyover_comment_show!
      if request.xhr?
        # byebug
        render partial: "flyover_comments/comments/replies", locals: {comment: @comment, collapsed: true}
      else
        respond_with @comment
      end
    end

    def update
      @comment = FlyoverComments::Comment.find(params[:id])
      @comment.assign_attributes(comment_params)
      authorize_flyover_comment_update!
      @comment.save
      respond_with @comment do |format|
        format.json{
          if @comment.errors.any?
            render json: { errors: @comment.errors }, status: :unprocessable_entity
          else
            render partial: "flyover_comments/comments/comment", locals: { comment: @comment }
          end
        }
      end
    end

    def destroy
      @comment = FlyoverComments::Comment.find(params[:id])
      if params[:hard_delete] == "true"
        authorize_flyover_comment_hard_deletion!
        @comment.destroy
      else
        authorize_flyover_comment_soft_deletion!
        @comment.deleted_at = Time.now
        @comment.save
      end
      respond_with @comment
    end

  private

    def comment_params
      params.require(:comment).permit(:content, :all_flags_reviewed)
    end

    def authorize_flyover_comment_index!
      _foc_authorize @comments
      raise "User isn't allowed to index comments" unless can_index_flyover_comments?(@comments, _flyover_comments_current_user)
    end

    def authorize_flyover_comment_show!
      _foc_authorize @comment
      raise "User isn't allowed to view comment" unless can_view_flyover_comment?(@comment, _flyover_comments_current_user)
    end

    def authorize_flyover_comment_update!
      _foc_authorize @comment
      raise "User isn't allowed to update comment" unless can_update_flyover_comment?(@comment, _flyover_comments_current_user)
    end

    def authorize_flyover_comment_creation!
      _foc_authorize @comment
      raise "User isn't allowed to create comment" unless can_create_flyover_comment?(@comment, _flyover_comments_current_user)
    end

    def authorize_flyover_comment_hard_deletion!
      _foc_authorize @comment, :hard_destroy?
      raise "User isn't allowed to delete comment" unless can_hard_delete_flyover_comment?(@comment, _flyover_comments_current_user)
    end

    def authorize_flyover_comment_soft_deletion!
      _foc_authorize @comment, :soft_destroy?
      raise "User isn't allowed to delete comment" unless can_soft_delete_flyover_comment?(@comment, _flyover_comments_current_user)
    end

  end
end
