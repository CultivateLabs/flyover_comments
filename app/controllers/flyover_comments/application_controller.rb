module FlyoverComments
  class ApplicationController < FlyoverComments.application_controller_superclass

    def _foc_authorize(record, action = nil)
      authorize(record, action) if Object.const_defined?("Pundit") && policy(record)
    end

    def authorize_flyover_comment_index!
      _foc_authorize @comments
      raise "User isn't allowed to index comments" unless can_index_flyover_comments?(@comments, _flyover_comments_current_user)
    end

    def authorize_flyover_comment_show!
      _foc_authorize @comment, :show?
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
