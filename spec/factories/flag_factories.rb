FactoryGirl.define do
  factory :flag, class: "FlyoverComments::Flag" do
    comment { FactoryGirl.create(:comment) }
    before(:create){|comment| comment.ident_user = FactoryGirl.create(:user) if comment.ident_user.nil? }
    sequence(:reason){|i| "flag-reason-#{i}" }
  end
end
