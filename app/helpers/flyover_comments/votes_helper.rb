module FlyoverComments
  module VotesHelper

    def vote_flyover_comment_buttons(comment, options = {})
      user = _flyover_comments_current_user

      if comment && can_vote_flyover_comment?(comment, user)
        vote = options[:vote]
        vote ||= FlyoverComments::Vote.find_or_initialize_by(voter: user, comment: comment)
        render "flyover_comments/votes/vote_buttons.html", options.merge({vote: vote, comment: comment})
      else
        render "flyover_comments/votes/vote_count.html", comment: comment
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
      vote.persisted? && vote.upvote? ? t('flyover_comments.votes.upvoted') : t('flyover_comments.votes.upvote')
    end

    def downvote_button_text(vote)
      vote.persisted? && vote.downvote? ? t('flyover_comments.votes.downvoted') : t('flyover_comments.votes.downvote')
    end

    def upvote_button_options(vote)
      method = vote_button_method(vote, 1)
      btn_class = method == :delete ? "btn-info" : "btn-success"
      {
        id: "upvote_flyover_comment_#{vote.comment.id}",
        method: method,
        params: { comment_id: vote.comment_id, value: 1 },
        class: "btn #{btn_class}",
        form_class: "button_to upvote-button vote-button",
        remote: true
      }
    end

    def downvote_button_options(vote)
      method = vote_button_method(vote, -1)
      btn_class = method == :delete ? "downvoted" : ""
      {
        id: "downvote_flyover_comment_#{vote.comment.id}",
        method: method,
        params: { comment_id: vote.comment_id, value: -1 },
        class: "btn btn-link btn-downvote #{btn_class}",
        form_class: "button_to downvote-button vote-button",
        remote: true
      }
    end

  end
end
