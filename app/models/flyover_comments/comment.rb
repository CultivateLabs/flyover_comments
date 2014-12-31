module FlyoverComments
  class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :commentable, polymorphic: true
    belongs_to :parent
  end
end
