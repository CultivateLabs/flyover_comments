module FlyoverComments
  class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :commentable, polymorphic: true
    belongs_to :parent

    validates :commentable_id, presence: true
    validates :user_id, presence: true
    validates :content, presence: true

    def commenter_name
      if user.respond_to?(:flyover_comments_name)
        user.flyover_comments_name
      elsif user.respond_to?(:name)
        user.name
      elsif user.respond_to?(:full_name)
        user.full_name
      else
        user.email
      end
    end
  end
end
