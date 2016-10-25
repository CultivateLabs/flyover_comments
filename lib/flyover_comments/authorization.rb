module FlyoverComments
  module Authorization

    def _flyover_comments_current_user
      send(FlyoverComments.current_user_method.to_sym)
    end

    def can_index_flyover_comments?(comments, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, comments)
        policy.index?
      elsif user.respond_to?(:can_index_flyover_comments?)
        user.can_index_flyover_comments?(params)
      else
        true
      end
    end

    def can_hard_delete_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, comment)
        policy.hard_destroy?
      elsif user.respond_to?(:can_hard_delete_flyover_comment?)
        user.can_hard_delete_flyover_comment?(comment)
      else
        false
      end
    end

    def can_soft_delete_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, comment)
        policy.soft_destroy?
      elsif user.respond_to?(:can_soft_delete_flyover_comment?)
        user.can_soft_delete_flyover_comment?(comment)
      else
        comment.commenter == user
      end
    end

    def can_view_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, comment)
        policy.show?
      elsif user.respond_to?(:can_view_flyover_comment?)
        user.can_view_flyover_comment?(comment)
      else
        true
      end
    end

    def can_create_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, comment)
        policy.create?
      elsif user.respond_to?(:can_create_flyover_comment?)
        user.can_create_flyover_comment?(comment)
      else
        comment.commenter == user
      end
    end

    def can_update_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, comment)
        policy.update?
      elsif user.respond_to?(:can_update_flyover_comment?)
        user.can_update_flyover_comment?(comment)
      else
        comment.commenter == user
      end
    end

    def can_flag_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, FlyoverComments::Flag.new(comment: comment, flagger: user))
        policy.create?
      elsif user.respond_to?(:can_flag_flyover_comment?)
        user.can_flag_flyover_comment?(comment)
      else
        !user.nil?
      end
    end

    def can_vote_flyover_comment?(comment, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, FlyoverComments::Vote.new(comment: comment, voter: user))
        policy.create?
      elsif user.respond_to?(:can_vote_flyover_comment?)
        user.can_vote_flyover_comment?(comment)
      else
        !user.nil?
      end
    end

    def can_update_flyover_vote?(vote, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, vote)
        policy.update?
      elsif user.respond_to?(:can_update_flyover_vote?)
        user.can_update_flyover_vote?(vote)
      else
        vote.voter == user
      end
    end

    def can_delete_flyover_vote?(vote, user)
      if Object.const_defined?("Pundit") && policy = Pundit.policy(user, vote)
        policy.destroy?
      elsif user.respond_to?(:can_delete_flyover_vote?)
        user.can_delete_flyover_vote?(vote)
      else
        vote.voter == user
      end
    end

  end
end
