FactoryGirl.define do
  factory :comment, class: "FlyoverComments::Comment" do
    user nil
    sequence(:content){|i| "comment-content-#{i}" }
  end
end
