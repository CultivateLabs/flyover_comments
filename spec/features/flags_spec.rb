require 'rails_helper'

RSpec.feature "Flags" do

  it "doesn't allow flagging if not logged in" do
    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, commentable: post)
    comment_to_flag = FactoryGirl.create(:comment, commentable: post, commenter: current_user)

    visit main_app.post_path(post)

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to_not have_button('Flag')
    expect(page).to have_content(comment_to_flag.content)

  end

  it "flags a comment", js: true do
    login

    post = FactoryGirl.create(:post)
    other_persons_comment = FactoryGirl.create(:comment, commentable: post)
    comment_to_flag = FactoryGirl.create(:comment, commentable: post, commenter: current_user)

    visit main_app.post_path(post)

    expect(page).to have_content(other_persons_comment.content)
    expect(page).to have_button('Flag')

    expect(page).to have_content(comment_to_flag.content)
    click_button "flag_flyover_comment_#{comment_to_flag.id}"

    expect(page).to have_button('Flag', disabled: true)

    flag = FlyoverComments::Flag.last
    expect(flag.comment_id).to eq(comment_to_flag.id)
    expect(flag.flagger).to eq(current_user)
    expect(flag.reviewed).to eq(false)

  end

end
