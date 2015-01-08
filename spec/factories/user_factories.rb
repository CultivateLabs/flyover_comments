FactoryGirl.define do
  factory :user, class: FlyoverComments.user_class do
    sequence(:email){|i| "user-#{i}@example.com" }
    password "password"
  end
end
