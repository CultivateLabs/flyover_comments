require_dependency "flyover_comments/application_controller"

module FlyoverComments
  class CommentsController < ApplicationController

    before_action :load_commentable

    def create
      @comment = FlyoverComments::Comment.new(comment_params)
      @comment.user = current_user
      @comment.commentable = @commentable

      flash_key = @comment.save ? :success : :error
      redirect_to :back, :flash => { flash_key => t("flyover_comments.flash.comments.create.#{flash_key.to_s}") }
    end

  private

    def comment_params
      params.require(:comment).permit(:content)      
    end

    def load_commentable
      commentable_type = params[:comment][:commentable_type].camelize.constantize
      raise "Invalid commentable type" if commentable_type.reflect_on_association(:comments).nil?
      @commentable = commentable_type.find(params[:comment][:commentable_id])
    end

  end
end
