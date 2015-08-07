module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to :user, class: FlyoverComments.user_class, foreign_key: "#{FlyoverComments.user_class_underscore}_id"

    validates :comment_id, presence: true, uniqueness: {scope: "#{FlyoverComments.user_class_underscore}_id"}
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

  end
end
