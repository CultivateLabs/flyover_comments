module FlyoverComments
  module VotesHelper

    def vote_buttons(voteable, membership, vote = nil)
      return if voteable.nil? || membership.nil?

      if membership == (voteable.respond_to?(:membership) ? voteable.membership : voteable.ident_membership)
        content_tag :span, pluralize(voteable.upvote_count, I18n.t('social.common.upvote')), class: "vote-count"
      else
        vote ||= FlyoverComments::Vote.find_or_initialize_by(membership: membership, voteable: voteable)
        render "flyover_comments/votes/vote_buttons.html", vote: vote, voteable: voteable
      end
    end

    def vote_button_method(vote, value)
      if vote.new_record? || vote.destroyed?
        :post
      elsif vote.value == value
        :delete
      else
        :patch
      end
    end

    def upvote_button_text(vote)
      vote.persisted? && vote.upvote? ? t('social.common.upvoted') : t('social.common.upvote')
    end

    def downvote_button_text(vote)
      vote.persisted? && vote.downvote? ? t('social.common.downvoted') : t('social.common.downvote')
    end

    def upvote_button_options(vote)
      method = vote_button_method(vote, 1)
      btn_class = method == :delete ? "btn-info" : "btn-success"
      {
        method: method,
        params: { voteable_id: vote.voteable_id, voteable_type: vote.voteable_type, value: 1 },
        class: "btn #{btn_class}",
        form_class: "button_to upvote-button vote-button",
        remote: true
      }
    end

    def downvote_button_options(vote)
      method = vote_button_method(vote, -1)
      btn_class = method == :delete ? "downvoted" : ""
      {
        method: method,
        params: { voteable_id: vote.voteable_id, voteable_type: vote.voteable_type, value: -1 },
        class: "btn btn-link btn-downvote #{btn_class}",
        form_class: "button_to downvote-button vote-button",
        remote: true
      }
    end

  end
end
