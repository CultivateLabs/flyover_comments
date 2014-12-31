FactoryGirl.define do
  factory :comment, class: Flyover::Comment do
    user
    post
    sequence(:content) { |i| "Comment ##{i}" }
  end
end