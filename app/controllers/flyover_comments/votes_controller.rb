require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class VotesController < ApplicationController
    include FlyoverComments::Authorization

    respond_to :json, only: [:create, :update, :destroy]

    before_action :load_vote, only: [:update, :destroy]

    def create
      @comment = FlyoverComments::Comment.find(params[:comment_id])
      @vote = @comment.votes.new(value: params[:value])
      @vote._user = _flyover_comments_current_user

      authorize_flyover_vote_create!

      @vote.save

      respond_with_vote_partial
    end

    def update
      authorize_flyover_vote_update!
      @vote.update(value: params[:value])
      respond_with_vote_partial
    end

    def destroy
      authorize_flyover_vote_delete!
      @vote.destroy
      respond_with_vote_partial
    end

  private

    def authorize_flyover_vote_create!
      _foc_authorize @vote
      raise "User #{_flyover_comments_current_user.id} isn't allowed to vote on comment #{@comment.id}" unless can_vote_flyover_comment?(@comment, _flyover_comments_current_user)
    end

    def authorize_flyover_vote_update!
      _foc_authorize @vote
      raise "User #{_flyover_comments_current_user.id} isn't allowed to update vote #{{vote_id: @vote.id, _user_id: @vote._user.id}}" unless can_update_flyover_vote?(@vote, _flyover_comments_current_user)
    end

    def authorize_flyover_vote_delete!
      _foc_authorize @vote
      raise "User #{_flyover_comments_current_user.id} isn't allowed to delete vote #{{vote_id: @vote.id, _user_id: @vote._user.id}}" unless can_delete_flyover_vote?(@vote, _flyover_comments_current_user)
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
