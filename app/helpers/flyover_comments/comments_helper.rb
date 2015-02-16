module FlyoverComments
  module CommentsHelper

    def flyover_comment_form(commentable)
      comment = FlyoverComments::Comment.new({
        commentable_id: commentable.id, 
        commentable_type: commentable.class.to_s
      })

      render "flyover_comments/comments/form", comment: comment
    end

    def flyover_comments_list(commentable)
      render "flyover_comments/comments/comments", commentable: commentable
    end
 
    def delete_flyover_comment_link(comment)
      opts = {
        id: "delete_flyover_comment_#{comment.id}", 
        class: "delete-flyover-comment-button", 
        data: { confirm: I18n.t('flyover_comments.comments.delete_confirmation'), flyover_comment_id: comment.id },
        method: :delete,
        remote: true
      }
      
      link_to I18n.t('flyover_comments.comments.delete_link_text'), flyover_comments.comment_path(comment), opts
    end

  end
end
