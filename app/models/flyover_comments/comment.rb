module FlyoverComments
  class Comment < ActiveRecord::Base
    belongs_to :user, class: FlyoverComments.user_class, foreign_key: "#{FlyoverComments.user_class_underscore}_id"
    belongs_to :commentable, polymorphic: true, counter_cache: FlyoverComments.enable_comment_counter_cache
    belongs_to :parent

    validates :commentable_id, presence: true
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true
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
