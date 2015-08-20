FactoryGirl.define do
  factory :comment, class: "FlyoverComments::Comment" do
    commentable { FactoryGirl.create(:post) }
    sequence(:content){|i| "comment-content-#{i}" }
    before(:create){|comment| comment.ident_user = FactoryGirl.create(:user) if comment.ident_user.nil? }
    parent_id nil
  end
end
