module FlyoverComments
  class Flag < ActiveRecord::Base
    belongs_to :comment
    belongs_to :user
  end
end
