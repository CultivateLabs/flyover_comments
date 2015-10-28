module FlyoverComments
  class Vote < ActiveRecord::Base
    belongs_to :comment
    belongs_to FlyoverComments.user_class_symbol, class_name: "#{FlyoverComments.user_class}", foreign_key: "#{FlyoverComments.user_class_underscore}_id"

    validates :comment_id, presence: true, uniqueness: {scope: "#{FlyoverComments.user_class_underscore}_id"}
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

    delegate FlyoverComments.user_class_symbol, to: :comment, prefix: true, allow_nil: true

    scope :upvotes, ->{ where value: 1 }
    scope :downvotes, ->{ where value: -1 }
    scope :created_after, ->(datetime){ where("flyover_comments_votes.created_at > ?", datetime) }

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
