module FlyoverComments
  class Comment < ActiveRecord::Base
    include FlyoverComments::LinkParsing

    belongs_to FlyoverComments.user_class_symbol, class_name: "#{FlyoverComments.user_class}", foreign_key: "#{FlyoverComments.user_class_underscore}_id"
    belongs_to :commentable, polymorphic: true, counter_cache: FlyoverComments.enable_comment_counter_cache
    belongs_to :parent, class_name: "FlyoverComments::Comment"

    has_many :children, class_name: "FlyoverComments::Comment", foreign_key: "parent_id"
    has_many :flags, dependent: :destroy

    validates :commentable, presence: true
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

    attr_accessor :all_flags_reviewed

    after_save :update_flags

    scope :with_unreviewed_flags, ->{ joins(:flags).where(flyover_comments_flags: { reviewed: false }) }
    scope :top_level, -> { where(parent_id: nil) }

    def content=(value)
      value = ERB::Util.html_escape(value) if FlyoverComments.auto_escapes_html_in_comment_content
      value = add_html_tags_to_detected_links(value) if FlyoverComments.insert_html_tags_for_detected_links
      self[:content] = value
    end

    def commenter_name
      user = send(FlyoverComments.user_class_underscore)
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

    def has_been_flagged_by?(flagger)
      flags.where(FlyoverComments.user_class_symbol => flagger).exists?
    end

    def update_flags
      if all_flags_reviewed
        flags.update_all reviewed: true
      end
    end

    def unreviewed_flag_count
      flags.not_reviewed.count
    end

    def _user
      send(FlyoverComments.user_class_symbol)
    end

    def _user=(val)
      send("#{FlyoverComments.user_class_symbol}=", val)
    end

  end
end
