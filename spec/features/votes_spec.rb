require 'rails_helper'

RSpec.feature "Votes" do

  it "doesn't allow voting if not logged in" do
    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, commentable: post)
    comment_to_vote = FactoryGirl.create(:comment, commentable: post, commenter: current_user)

    visit main_app.post_path(post)

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to_not have_button('Upvote')
    expect(page).to_not have_button('Downvote')
    expect(page).to have_content(comment_to_vote.content)
  end

  it "upvotes a comment", js: true do
    login

    post = FactoryGirl.create(:post)
    comment_to_upvote = FactoryGirl.create(:comment, commentable: post, commenter: current_user)

    visit main_app.post_path(post)

    expect(page).to have_button('Upvote')
    expect(page).to have_button('Downvote')
    expect(page).to_not have_button('Upvoted')
    expect(page).to_not have_button('Downvoted')

    expect(page).to have_content(comment_to_upvote.content)
    click_button "upvote_flyover_comment_#{comment_to_upvote.id}"

    expect(page).to have_button('Upvoted')
    #expect(page).to_not have_button('Upvote')
    expect(page).to_not have_button('Downvoted')
    expect(page).to have_button('Downvote')

    vote = FlyoverComments::Vote.last
    expect(vote.comment_id).to eq(comment_to_upvote.id)
    expect(vote.voter).to eq(current_user)
    expect(vote.value).to eq(1)
    expect(vote.comment.upvote_count).to eq(1)
    expect(vote.comment.downvote_count).to eq(0)
  end

  it "downvotes a comment", js: true do
    login

    post = FactoryGirl.create(:post)
    comment_to_downvote = FactoryGirl.create(:comment, commentable: post, commenter: current_user)

    visit main_app.post_path(post)

    expect(page).to have_button('Upvote')
    expect(page).to have_button('Downvote')
    expect(page).to_not have_button('Upvoted')
    expect(page).to_not have_button('Downvoted')

    expect(page).to have_content(comment_to_downvote.content)
    click_button "downvote_flyover_comment_#{comment_to_downvote.id}"

    expect(page).to_not have_button('Upvoted')
    expect(page).to have_button('Upvote')
    expect(page).to have_button('Downvoted')
    #expect(page).to_not have_button('Downvote')

    vote = FlyoverComments::Vote.last
    expect(vote.comment_id).to eq(comment_to_downvote.id)
    expect(vote.voter).to eq(current_user)
    expect(vote.value).to eq(-1)
    expect(vote.comment.upvote_count).to eq(0)
    expect(vote.comment.downvote_count).to eq(1)
  end


end
