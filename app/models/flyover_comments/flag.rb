module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to :commenter, polymorphic: true

    validates :comment_id, presence: true, uniqueness: {scope: [:commenter_id, :commenter_type]}
    validates :commenter_id, presence: true
    validates :commenter_type, presence: true

    delegate FlyoverComments.user_class_symbol, to: :comment, prefix: true, allow_nil: true

    scope :not_reviewed, ->{ where reviewed: false }

    def _user=(val)
      send("#{FlyoverComments.user_class_symbol}=", val)
    end

    def _user
      send(FlyoverComments.user_class_symbol)
    end

  end
end
