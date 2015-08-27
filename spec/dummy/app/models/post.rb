class Post < ActiveRecord::Base
  belongs_to :ident_user, class_name: "Ident::User"
  flyover_commentable
end
