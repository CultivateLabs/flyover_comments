module FlyoverComments
  class Vote < ActiveRecord::Base
    belongs_to :comment
    belongs_to FlyoverComments.user_class_symbol, class_name: "#{FlyoverComments.user_class}", foreign_key: "#{FlyoverComments.user_class_underscore}_id"

    validates :comment_id, presence: true, uniqueness: {scope: "#{FlyoverComments.user_class_underscore}_id"}
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

    delegate FlyoverComments.user_class_symbol, to: :comment, prefix: true, allow_nil: true

    scope :upvotes, ->{ where("flyover_comments_votes.value > 0") }
    scope :downvotes, ->{ where("flyover_comments_votes.value < 0") }
    scope :created_after, ->(datetime){ where("flyover_comments_votes.created_at > ?", datetime) }

    before_create :increment_comment_counter_cache
    before_update :update_comment_counter_caches_for_value_change
    after_destroy :decrement_comment_counter_cache

    def increment_comment_counter_cache
      if upvote?
        FlyoverComments::Comment.increment_counter(:upvote_count, comment_id)
        comment.upvote_count += 1
      elsif downvote?
        FlyoverComments::Comment.increment_counter(:downvote_count, comment_id)
        comment.downvote_count += 1
      end
    end

    def decrement_comment_counter_cache
      if upvote?
        FlyoverComments::Comment.decrement_counter(:upvote_count, comment_id)
        comment.upvote_count -= 1
      elsif downvote?
        FlyoverComments::Comment.decrement_counter(:downvote_count, comment_id)
        comment.downvote_count -= 1
      end
    end

    def update_comment_counter_caches_for_value_change
      if value_changed?
        if upvote?
          FlyoverComments::Comment.increment_counter(:upvote_count, comment_id)
          comment.upvote_count += 1
          FlyoverComments::Comment.decrement_counter(:downvote_count, comment_id)
          comment.downvote_count -= 1
        else
          FlyoverComments::Comment.increment_counter(:downvote_count, comment_id)
          comment.downvote_count += 1
          FlyoverComments::Comment.decrement_counter(:upvote_count, comment_id)
          comment.upvote_count -= 1
        end
      end
    end

    def _user=(val)
      send("#{FlyoverComments.user_class_symbol}=", val)
    end

    def _user
      send(FlyoverComments.user_class_symbol)
    end

    def upvote?
      value && value > 0
    end

    def downvote?
      value && value < 0
    end

  end
end
