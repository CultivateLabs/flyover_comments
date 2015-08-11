require 'rails_helper'

RSpec.feature "Comments" do

  before{ login }

  it "creates a comment" do
    post = FactoryGirl.create(:post)
    comment_count = post.comments.count

    visit main_app.post_path(post)

    fill_in "comment_content", with: "Here's some comment content"
    click_button "Create Comment"

    expect(page).to have_content(I18n.t('flyover_comments.comments.flash.create.success'))
    expect(post.comments.count).to eq(comment_count + 1)
    comment = post.comments.last
    expect(comment.content).to eq("Here's some comment content")
    expect(comment.user).to eq(current_user)
  end

  it "shows a list of comments" do
    post = FactoryGirl.create(:post)
    c1 = FactoryGirl.create(:comment, commentable: post)
    c2 = FactoryGirl.create(:comment, commentable: post)
    c3 = FactoryGirl.create(:comment)

    visit main_app.post_path(post)

    [c1, c2].each do |comment|
      within "#flyover_comment_#{c1.id}" do
        expect(page).to have_content(c1.content)
        expect(page).to have_content(c1.commenter_name)
      end
    end

    expect(page).to_not have_content(c3.content)
  end

  it "deletes a comment", js: true do
    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, commentable: post)
    comment_to_delete = FactoryGirl.create(:comment, commentable: post, user: current_user)

    visit main_app.post_path(post)

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to_not have_link("delete_flyover_comment_#{other_persons_comment.id}")

    expect(page).to have_content(comment_to_delete.content)
    click_link "delete_flyover_comment_#{comment_to_delete.id}"

    expect(page).to_not have_content(comment_to_delete.content)

    expect{ comment_to_delete.reload }.to raise_error
  end

  it "sets a comment as reviewed", js: true do

    post = FactoryGirl.create(:post)
    comment = FactoryGirl.create(:comment, commentable: post, user: current_user)
    flag = FactoryGirl.create(:flag, comment: comment, user: current_user)

    visit main_app.flags_path

    expect(flag.reviewed).to eq(false)
    expect(page).to have_content(comment.content)
    expect(page).to have_selector("input[value='Approve']")

    click_button "Approve"
    expect(page).to_not have_content(comment.content)
    expect(page).to_not have_selector("input[value='Approve']")

    flag.reload
    expect(flag.reviewed).to eq(true)

  end

end
