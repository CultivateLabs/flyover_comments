FactoryGirl.define do
  factory :comment, class: "FlyoverComments::Comment" do
    commentable { FactoryGirl.create(:post) }
    sequence(:content){|i| "comment-content-#{i}" }
    before(:create){|comment| comment.user = FactoryGirl.create(:user) if comment.user.nil? }
  end
end
