FactoryGirl.define do
  factory :flag, class: "FlyoverComments::Flag" do
    comment { FactoryGirl.create(:comment) }
    before(:create){|comment| comment.user = FactoryGirl.create(:user) if comment.user.nil? }
  end
end
