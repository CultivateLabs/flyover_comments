module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to FlyoverComments.user_class_symbol, class_name: "#{FlyoverComments.user_class}", foreign_key: "#{FlyoverComments.user_class_underscore}_id"

    validates :comment_id, presence: true, uniqueness: {scope: "#{FlyoverComments.user_class_underscore}_id"}
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

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
