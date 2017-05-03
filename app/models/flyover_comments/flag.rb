module FlyoverComments
  class Flag < ActiveRecord::Base
    include FlyoverComments::Concerns::FlagAdditions
    belongs_to :comment
    belongs_to :flagger, polymorphic: true

    validates :comment_id, presence: true, uniqueness: {scope: [:flagger_id, :flagger_type]}
    validates :flagger_id, presence: true
    validates :flagger_type, presence: true

    delegate FlyoverComments.user_class_symbol, to: :comment, prefix: true, allow_nil: true

    scope :not_reviewed, ->{ where(reviewed: false) }

    def _user=(val)
      send("#{FlyoverComments.user_class_symbol}=", val)
    end

    def _user
      send(FlyoverComments.user_class_symbol)
    end

  end
end
