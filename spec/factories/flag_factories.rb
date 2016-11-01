FactoryGirl.define do
  factory :flag, class: "FlyoverComments::Flag" do
    comment { FactoryGirl.create(:comment) }
    before(:create){|flag| flag.flagger = FactoryGirl.create(:user) if flag.flagger.nil? }
    sequence(:reason){|i| "flag-reason-#{i}" }
  end
end
