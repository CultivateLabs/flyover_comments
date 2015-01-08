class Post < ActiveRecord::Base
  belongs_to :ident_user, class: Ident::User
  flyover_commentable
end
