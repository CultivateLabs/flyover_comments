require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class VotesController < ApplicationController
    include FlyoverComments::Authorization

    respond_to :json, only: [:create, :destroy]

    before_action :load_vote, only: [:update, :destroy]

    def create
      @comment = FlyoverComments::Comment.find(params[:comment_id])
      authorize_flyover_vote_create!
      @vote = @comment.votes.new(value: params[:value])
      @vote._user = send(FlyoverComments.current_user_method.to_sym)

      if @vote.save
        @comment.recalculate_vote_counts!
      end

      respond_with_vote_partial
    end

    def update
      authorize_flyover_vote_update!
      @vote.update(value: params[:value])
      @vote.comment.recalculate_vote_counts!
      respond_with_vote_partial
    end

    def destroy
      authorize_flyover_vote_delete!
      @vote.destroy
      @vote.comment.recalculate_vote_counts!
      respond_with_vote_partial
    end

  private


    def authorize_flyover_vote_create!
      raise "User isn't allowed to vote on comment" unless can_vote_flyover_comment?(@comment, send(FlyoverComments.current_user_method.to_sym))
    end

    def authorize_flyover_vote_update!
      raise "User isn't allowed to update vote" unless can_update_flyover_vote?(@vote, send(FlyoverComments.current_user_method.to_sym))
    end

    def authorize_flyover_vote_delete!
      raise "User isn't allowed to delete vote" unless can_delete_flyover_vote?(@vote, send(FlyoverComments.current_user_method.to_sym))
    end

    def load_vote
      @vote = FlyoverComments::Vote.find(params[:id])
    end

    def respond_with_vote_partial
      @include_buttons_html = true

      respond_with @vote do |format|
        format.json{ render partial: "flyover_comments/votes/vote", locals: { vote: @vote } }
      end
    end

  end
end
