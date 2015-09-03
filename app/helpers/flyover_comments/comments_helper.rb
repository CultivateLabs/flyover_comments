module FlyoverComments
  module CommentsHelper

    def flyover_comment_form(commentable, comment = nil,  parent: nil, form: {})
      comment ||= FlyoverComments::Comment.new({
        commentable_id: commentable.id,
        commentable_type: commentable.class.to_s,
        parent: parent
      })

      render "flyover_comments/comments/form", comment: comment, form_opts: form
    end

    def flyover_comments_list(commentable)
      render "flyover_comments/comments/comments", commentable: commentable
    end

    def flyover_comment_replies(comment, collapsed: true)
      render "flyover_comments/comments/replies", comment: comment, collapsed: collapsed
    end

    def edit_flyover_comment_link(comment, content = I18n.t('flyover_comments.comments.edit_link_text'), opt_overrides = {})
      return unless comment && can_update_flyover_comment?(comment, send(FlyoverComments.current_user_method.to_sym))

      opts = {
        id: "edit_flyover_comment_#{comment.id}",
        class: "edit-flyover-comment-link",
        data: {
          flyover_comment_id: comment.id,
          url: flyover_comments.comment_path(comment)
        },
      }.merge(opt_overrides)

      link_to content, flyover_comments.comment_path(comment), opts
    end

    def delete_flyover_comment_link(comment, content = I18n.t('flyover_comments.comments.delete_link_text'), opt_overrides = {})
      return unless comment && can_delete_flyover_comment?(comment, send(FlyoverComments.current_user_method.to_sym))

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

    def flag_flyover_comment_link(comment, content = I18n.t('flyover_comments.comments.flag_link_text'), opt_overrides = {})
      user = send(FlyoverComments.current_user_method.to_sym)
      return unless comment && can_flag_flyover_comment?(comment, user)

      opts = {
        id: "flag_flyover_comment_#{comment.id}",
        class: "flag-flyover-comment-button",
        data: {
          confirm: I18n.t('flyover_comments.comments.flag_confirmation'),
          flyover_comment_id: comment.id
        },
        method: :post,
        remote: true,
        form: { data: { type: "script" } }
      }.merge(opt_overrides)

      if FlyoverComments::Flag.where(:comment => comment, FlyoverComments.user_class_symbol => user).exists?
        opts[:disabled] = 'disabled'
        content = t('flyover_comments.flags.flagged')
      end

      button_to content, flyover_comments.comment_flags_path(comment), opts
    end

    def mark_flyover_comment_flags_reviewed_link(comment, content = I18n.t('flyover_comments.comments.approve_link_text'), opt_overrides = {})

      opts = {
        id: "approve_flyover_comment_#{comment.id}",
        class: "approve-flyover-comment-button",
        data: {
          confirm: I18n.t('flyover_comments.comments.approve_confirmation'),
          flyover_comment_id: comment.id
        },
        params: {
          "comment[all_flags_reviewed]" => true
        },
        method: :patch,
        remote: true,
        form: { data: { type: "script" } }
      }.merge(opt_overrides)


      button_to content, flyover_comments.comment_path(comment), opts
    end
  end
end
