require 'rails_helper'

RSpec.feature "Comments" do

  before{ login }

  it "creates a comment" do
    post = FactoryGirl.create(:post)
    comment_count = post.comments.count

    visit main_app.post_path(post)

    fill_in "comment_content", with: "Here's some comment content"
    click_button "Create Comment"

    expect(page).to have_content(I18n.t('flyover_comments.flash.comments.create.success'))
    expect(post.comments.count).to eq(comment_count + 1)
    comment = post.comments.last
    expect(comment.content).to eq("Here's some comment content")
    expect(comment.user).to eq(current_user)
  end

  # it "deletes a comment", js: true do
  #   post = FactoryGirl.create(:post)
  #   other_persons_comment = FactoryGirl.create(:comment, commentable: post)
  #   comment_to_delete = FactoryGirl.create(:comment, commentable: post, user: current_user)

  #   visit main_app.post_path(post)

  #   expect(page).to have_content(other_persons_comment.content)
  #   expect(page).to_not have_link("delete_comment_#{other_persons_comment.id}")

  #   expect(page).to have_content(comment_to_delete.content)
  #   click_link "delete_comment_#{comment_to_delete.id}"
    
  #   expect(page).to_not have_content(comment_to_delete.content)

  #   expect{ comment_to_delete.reload }.to raise_error
  # end
  
end
