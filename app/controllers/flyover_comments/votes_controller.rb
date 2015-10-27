require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class VotesController < ApplicationController
    include FlyoverComments::Authorization

    respond_to :json, only: [:create, :destroy]

    before_action :load_vote, only: [:update, :destroy]

    def create
      @comment = FlyoverComments::Comment.find(params[:comment_id])
      authorize_flyover_vote_creation!
      @vote = comment.votes.new(value: params[:value])
      @comment._user = send(FlyoverComments.current_user_method.to_sym)

      authorize @vote
      @vote.save

      respond_with_vote_partial
    end

    def update
      authorize @vote
      @vote.update(value: params[:value])
      respond_with_vote_partial
    end

    def destroy
      authorize @vote
      @vote.destroy
      respond_with_vote_partial
    end

  private

    def load_vote
      @vote = FlyoverComments::Vote.find(params[:id])
    end

    def respond_with_vote_partial
      @include_buttons_html = true

      respond_with @vote do |format|
        format.json{ render partial: "social/api/v1/votes/vote", locals: { vote: @vote } }
      end
    end

  end
end
