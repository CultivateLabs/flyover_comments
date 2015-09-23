require 'rails_helper'

RSpec.feature "Comments" do

  before{ login }

  it "creates a comment" do
    post = FactoryGirl.create(:post)
    comment_count = post.comments.count

    visit main_app.post_path(post)

    fill_in "comment_content", with: "Some comment content"
    click_button "Submit"

    expect(page).to have_content(I18n.t('flyover_comments.comments.flash.create.success'))
    expect(post.comments.count).to eq(comment_count + 1)
    comment = post.comments.last
    expect(comment.content).to eq("Some comment content")
    expect(comment._user).to eq(current_user)
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

  it "edits a comment", js: true do
    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, commentable: post)
    comment_to_edit = FactoryGirl.create(:comment, commentable: post, ident_user: current_user)
    new_content = "Updated comment content"
    expect(comment_to_edit.last_updated_at).to eq(nil)

    visit main_app.post_path(post)

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to_not have_link("edit_flyover_comment_#{other_persons_comment.id}")

    expect(page).to have_content(comment_to_edit.content)
    within(:css, "#flyover_comment_#{comment_to_edit.id}") do
      click_link "edit_flyover_comment_#{comment_to_edit.id}"
      fill_in "comment_content_#{comment_to_edit.id}", with: new_content
      click_button "Submit"
    end

    expect(page).to_not have_content(comment_to_edit.content)
    expect(page).to have_content(new_content)

    expect(comment_to_edit.reload.content).to eq(new_content)
    expect(comment_to_edit.reload.last_updated_at).to_not eq(nil)
  end

  it "deletes a comment", js: true do
    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, commentable: post)
    comment_to_delete = FactoryGirl.create(:comment, commentable: post, ident_user: current_user)

    visit main_app.post_path(post)

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to_not have_link("delete_flyover_comment_#{other_persons_comment.id}")

    expect(page).to have_content(comment_to_delete.content)
    click_link "delete_flyover_comment_#{comment_to_delete.id}"

    expect(page).to_not have_content(comment_to_delete.content)
    expect(page).to have_content(comment_to_delete.deleted_at.to_s(:normal))

    expect{ comment_to_delete.reload }.to raise_error
  end

  it "sets a comment as reviewed", js: true do

    post = FactoryGirl.create(:post)
    comment = FactoryGirl.create(:comment, commentable: post, ident_user: current_user)
    flag = FactoryGirl.create(:flag, comment: comment, ident_user: current_user)

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

  it "views a comment as replies", js: true do

    post = FactoryGirl.create(:post)
    comment = FactoryGirl.create(:comment, commentable: post, ident_user: current_user)
    sub_comment1 = FactoryGirl.create(:comment, commentable: post, parent_id: comment.id, ident_user: current_user)
    sub_comment2 = FactoryGirl.create(:comment, commentable: post, parent_id: comment.id, ident_user: current_user)

    visit main_app.post_path(post)

    expect(page).to have_content(comment.content)
    expect(page).to have_content(sub_comment2.content)
    expect(page).to_not have_content(sub_comment1.content)
    expect(page).to have_content('Load more comments')

    click_link 'Load more comments'

    expect(page).to have_content(comment.content)
    expect(page).to have_content(sub_comment2.content)
    expect(page).to have_content(sub_comment1.content)
    expect(page).to_not have_content('Load more comments')
  end

end
