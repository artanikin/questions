FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user, aliases: [:author] do
    email
    password 'pass123'
    password_confirmation 'pass123'

    factory :user_with_questions do
      transient do
        question_count 2
      end

      after(:create) do |author, evaluator|
        create_list(:question, evaluator.question_count, author: author)
      end
    end
  end

end
