FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user, aliases: [:author] do
    email
    password 'pass123'
    password_confirmation 'pass123'
    confirmed_at Time.now

    factory :user_with_questions do
      transient do
        question_count 2
      end

      after(:create) do |author, evaluator|
        create_list(:question, evaluator.question_count, author: author)
      end
    end

    factory :user_with_question_and_answers do
      transient do
        answer_count 2
      end

      after(:create) do |author, evaluator|
        create(:question_with_answers, author: author)
      end
    end
  end

end
