FactoryGirl.define do
  factory :comment, class: "FlyoverComments::Comment" do
    user
    commentable { FactoryGirl.create(:post) }
    sequence(:content){|i| "comment-content-#{i}" }
  end
end
