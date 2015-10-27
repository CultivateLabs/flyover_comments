module FlyoverComments
  class Vote < ActiveRecord::Base
    belongs_to :flyover_comments_comment
    belongs_to :user_symbol
  end
end
