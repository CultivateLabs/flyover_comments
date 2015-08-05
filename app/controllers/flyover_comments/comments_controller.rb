require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class CommentsController < ApplicationController
    include FlyoverComments::Authorization

    before_action :load_commentable, only: :create
    
    respond_to :json, only: [:create]
    respond_to :html, only: [:create]
    respond_to :js, only: [:destroy]

    def create
      @parent = FlyoverComments::Comment.find(params[:comment].delete(:parent_id)) if !params[:comment][:parent_id].blank?
      @comment = FlyoverComments::Comment.new(comment_params)
      @comment.user = send(FlyoverComments.current_user_method.to_sym)
      @comment.commentable = @commentable
      @comment.parent = @parent
      authorize_flyover_comment_creation!

      flash_key = @comment.save ? :success : :error
      respond_with @comment do |format|
        format.html{ redirect_to :back, :flash => { flash_key => t("flyover_comments.comments.flash.create.#{flash_key.to_s}") } }
        format.json{ render partial: "flyover_comments/comments/comment", locals: { comment: @comment } }
      end
    end

    def destroy
      @comment = FlyoverComments::Comment.find(params[:id])
      authorize_flyover_comment_deletion!
      @comment.destroy
      respond_with @comment
    end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def load_commentable
      commentable_type = params[:comment].delete(:commentable_type).camelize.constantize
      raise "Invalid commentable type" if commentable_type.reflect_on_association(:comments).nil?
      @commentable = commentable_type.find(params[:comment].delete(:commentable_id))
    end

    def authorize_flyover_comment_creation!
      raise "User isn't allowed to create comment" unless can_create_flyover_comment?(@comment, send(FlyoverComments.current_user_method.to_sym))
    end

    def authorize_flyover_comment_deletion!
      raise "User isn't allowed to delete comment" unless can_delete_flyover_comment?(@comment, send(FlyoverComments.current_user_method.to_sym))
    end

  end
end
