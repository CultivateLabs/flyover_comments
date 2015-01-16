require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class CommentsController < ApplicationController
    include FlyoverComments::Authorization

    before_action :load_commentable, only: :create
    
    respond_to :json, only: :destroy

    def create
      @comment = FlyoverComments::Comment.new(comment_params)
      @comment.user = current_user
      @comment.commentable = @commentable
      authorize_flyover_comment_creation!

      flash_key = @comment.save ? :success : :error
      redirect_to :back, :flash => { flash_key => t("flyover_comments.comments.flash.create.#{flash_key.to_s}") }
    end

    def destroy
      @comment = FlyoverComments::Comment.find(params[:id])
      authorize_flyover_comment_deletion!
      @comment.destroy
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
      if current_user.respond_to?(:can_create_flyover_comment?)
        raise "User isn't allowed to create comment" unless can_create_flyover_comment(@comment, current_user)
      end
    end

    def authorize_flyover_comment_deletion!
      if current_user.respond_to?(:can_destroy_flyover_comment?)
        raise "User isn't allowed to delete comment" unless can_delete_flyover_comment?(@comment, current_user)
      end
    end

  end
end
