module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to :user, class: FlyoverComments.user_class, foreign_key: "#{FlyoverComments.user_class_underscore}_id"

    validates :comment_id, presence: true, uniqueness: {scope: "#{FlyoverComments.user_class_underscore}_id"}
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

    delegate :user, to: :comment, prefix: true, allow_nil: true

    scope :not_reviewed, ->{ where reviewed: false }

  end
end
