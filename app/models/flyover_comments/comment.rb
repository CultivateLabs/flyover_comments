module FlyoverComments
  class Comment < ActiveRecord::Base
    belongs_to :user, class: FlyoverComments.user_class, foreign_key: "#{FlyoverComments.user_class_underscore}_id"
    belongs_to :commentable, polymorphic: true, counter_cache: FlyoverComments.enable_comment_counter_cache
    belongs_to :parent, class_name: "FlyoverComments::Comment"

    has_many :children, class_name: "FlyoverComments::Comment", foreign_key: "parent_id"
    has_many :flags, dependent: :destroy

    validates :commentable, presence: true
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true
    validates :content, presence: true
    
    attr_accessor :all_flags_reviewed
    
    after_save :update_flags

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
    
    def update_flags
      if all_flags_reviewed
        flags.update_all reviewed: true
      end
    end
  end
end
