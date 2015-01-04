class Post < ActiveRecord::Base
  belongs_to :user
  flyover_commentable
end
