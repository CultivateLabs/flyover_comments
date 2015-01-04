module FlyoverComments
  module CommentsHelper

    def flyover_comment_form(commentable)
      comment = FlyoverComments::Comment.new({
        commentable_id: commentable.id, 
        commentable_type: commentable.class.to_s
      })

      render "flyover_comments/comments/form", comment: comment
    end

    def flyover_comments_list
      render "flyover_comments/comments/comments"
    end

  end
end
