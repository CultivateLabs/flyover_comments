module FlyoverComments
  class Comment < ActiveRecord::Base
    include FlyoverComments::LinkParsing

    scope :with_includes, -> { }

    include FlyoverComments::Concerns::CommentAdditions

    paginates_per 10

    belongs_to FlyoverComments.user_class_symbol, class_name: "#{FlyoverComments.user_class}", foreign_key: "#{FlyoverComments.user_class_underscore}_id"
    belongs_to :commentable, polymorphic: true, counter_cache: FlyoverComments.enable_comment_counter_cache
    belongs_to :parent, class_name: "FlyoverComments::Comment"

    has_many :children, ->{ order(:created_at) } , class_name: "FlyoverComments::Comment", foreign_key: "parent_id"
    has_many :flags, dependent: :destroy
    has_many :votes, dependent: :destroy

    validates :commentable, presence: true
    validates "#{FlyoverComments.user_class_underscore}_id", presence: true

    attr_accessor :all_flags_reviewed

    before_save :update_last_edited_at
    before_save :update_contains_links
    after_save :update_flags

    after_create :increment_children_counter_cache
    after_destroy :decrement_children_counter_cache

    scope :with_unreviewed_flags, ->{ joins(:flags).where(flyover_comments_flags: { reviewed: false }) }
    scope :with_links, ->{ where(contains_links: true) }
    scope :top_level, -> { where(parent_id: nil) }
    scope :newest_first, -> { order(created_at: :desc) }
    scope :highest_net_votes, -> { order("flyover_comments_comments.upvote_count - flyover_comments_comments.downvote_count DESC") }
    scope :not_blank, -> { where("content <> ''") }

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

    def page
      return 1 if parent.nil?
      previous_comment_count = parent.children.where(["created_at < ?", created_at]).count
      previous_comment_count / self.class.default_per_page + 1
    end

    def update_last_edited_at
      self.last_updated_at = Time.now if content_changed? && id
    end

    def update_contains_links
      self.contains_links = contains_links?(:content)
      return # prevent callback chain from aborting if this is false
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

    def recalculate_vote_counts!
      recalculate_upvote_count!
      recalculate_downvote_count!
    end

    def recalculate_upvote_count!
      self.update_attribute(:upvote_count, votes.upvotes.count)
    end

    def recalculate_downvote_count!
      self.update_attribute(:downvote_count, votes.downvotes.count)
    end

    def net_votes_count
      upvote_count - downvote_count
    end

    def vote_value_for_user(user)
      votes.where(FlyoverComments.user_class_symbol => user).pluck(:value).first || 0
    end

  private

    def increment_children_counter_cache
      self.class.increment_counter("children_count", parent_id) unless parent_id.nil?
    end

    def decrement_children_counter_cache
      self.class.decrement_counter("children_count", parent_id) unless parent_id.nil?
    end

  end
end
