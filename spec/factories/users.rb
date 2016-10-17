FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password 'pass123'
    password_confirmation 'pass123'
  end
end
