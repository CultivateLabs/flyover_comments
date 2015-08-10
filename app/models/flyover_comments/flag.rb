module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to :user, class: FlyoverComments.user_class, foreign_key: "#{FlyoverComments.user_class_underscore}_id"

    validates :comment_id, presence: true, uniqueness: {scope: "#{FlyoverComments.user_class_underscore}_id"}
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

    delegate :user, to: :comment, prefix: true, allow_nil: true

    after_create: set_flag


    def set_flag
      if !self.approved?
        update_attribute(:flagged, true)
      end
    end

  end
end
