require 'rails_helper'

module FlyoverComments
  RSpec.describe Vote, :type => :model do

    let(:comment) { FactoryGirl.create(:comment) }
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    describe "#create" do

      it "increments vote count on upvote" do
        vote = comment.votes.create(value: 1, ident_user: user)
        comment.reload
        expect(comment.upvote_count).to eq(1)
        expect(comment.downvote_count).to eq(0)
        expect(comment.net_votes_count).to eq(1)
        expect(comment.vote_value_for_user(user)).to eq(1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
      end

      it "decrements vote count on downvote" do
        vote = comment.votes.create(value: -1, ident_user: user)
        comment.reload
        expect(comment.upvote_count).to eq(0)
        expect(comment.downvote_count).to eq(1)
        expect(comment.net_votes_count).to eq(-1)
        expect(comment.vote_value_for_user(user)).to eq(-1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
      end

    end

    describe "#update" do

      it "increments vote count on upvote update" do
        vote = comment.votes.create(value: -1, ident_user: user)
        comment.reload
        expect(comment.upvote_count).to eq(0)
        expect(comment.downvote_count).to eq(1)
        expect(comment.net_votes_count).to eq(-1)
        expect(comment.vote_value_for_user(user)).to eq(-1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
        vote.value = 1
        vote.save
        comment.reload
        expect(comment.upvote_count).to eq(1)
        expect(comment.downvote_count).to eq(0)
        expect(comment.net_votes_count).to eq(1)
        expect(comment.vote_value_for_user(user)).to eq(1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
      end

      it "decrements vote count on downvote update" do
        vote = comment.votes.create(value: 1, ident_user: user)
        comment.reload
        expect(comment.upvote_count).to eq(1)
        expect(comment.downvote_count).to eq(0)
        expect(comment.net_votes_count).to eq(1)
        expect(comment.vote_value_for_user(user)).to eq(1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
        vote.value = -1
        vote.save
        comment.reload
        expect(comment.upvote_count).to eq(0)
        expect(comment.downvote_count).to eq(1)
        expect(comment.net_votes_count).to eq(-1)
        expect(comment.vote_value_for_user(user)).to eq(-1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
      end

    end

    describe "#destroy" do

      it "decrements vote count on upvote destroy" do
        vote = comment.votes.create(value: 1, ident_user: user)
        comment.reload
        expect(comment.upvote_count).to eq(1)
        expect(comment.downvote_count).to eq(0)
        expect(comment.net_votes_count).to eq(1)
        expect(comment.vote_value_for_user(user)).to eq(1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
        vote.destroy
        comment.reload
        expect(comment.upvote_count).to eq(0)
        expect(comment.downvote_count).to eq(0)
        expect(comment.net_votes_count).to eq(0)
        expect(comment.vote_value_for_user(user)).to eq(0)
        expect(comment.vote_value_for_user(user2)).to eq(0)
      end

      it "increments vote count on downvote destroy" do
        vote = comment.votes.create(value: -1, ident_user: user)
        comment.reload
        expect(comment.upvote_count).to eq(0)
        expect(comment.downvote_count).to eq(1)
        expect(comment.net_votes_count).to eq(-1)
        expect(comment.vote_value_for_user(user)).to eq(-1)
        expect(comment.vote_value_for_user(user2)).to eq(0)
        vote.destroy
        comment.reload
        expect(comment.upvote_count).to eq(0)
        expect(comment.downvote_count).to eq(0)
        expect(comment.net_votes_count).to eq(0)
        expect(comment.vote_value_for_user(user)).to eq(0)
        expect(comment.vote_value_for_user(user2)).to eq(0)
      end

    end

  end
end
