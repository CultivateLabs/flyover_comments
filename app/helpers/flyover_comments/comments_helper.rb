module FlyoverComments
  module CommentsHelper

    def flyover_comment_form(commentable, parent: nil, form: {})
      comment = FlyoverComments::Comment.new({
        commentable_id: commentable.id, 
        commentable_type: commentable.class.to_s,
        parent: parent
      })

      render "flyover_comments/comments/form", comment: comment, form_opts: form
    end

    def flyover_comments_list(commentable)
      render "flyover_comments/comments/comments", commentable: commentable
    end
 
    def delete_flyover_comment_link(comment, content = I18n.t('flyover_comments.comments.delete_link_text'), opt_overrides = {})
      return unless can_delete_flyover_comment?(comment, send(FlyoverComments.current_user_method.to_sym))
      
      opts = {
        id: "delete_flyover_comment_#{comment.id}", 
        class: "delete-flyover-comment-button", 
        data: { 
          type: "script",
          confirm: I18n.t('flyover_comments.comments.delete_confirmation'), 
          flyover_comment_id: comment.id 
        },
        method: :delete,
        remote: true
      }.merge(opt_overrides)
      
      link_to content, flyover_comments.comment_path(comment), opts
    end

  end
end
