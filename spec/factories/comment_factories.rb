FactoryGirl.define do
  factory :comment, class: "FlyoverComments::Comment" do
    commentable { FactoryGirl.create(:post) }
    sequence(:content){|i| "comment-content-#{i}" }
    before(:create){|comment| comment.commenter = FactoryGirl.create(:user) if comment.commenter.nil? }
    parent_id nil
  end
end
