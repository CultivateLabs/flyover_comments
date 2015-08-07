module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to :user

    validates :comment_id, :user_id, presence: true
  end
end
