FactoryGirl.define do
  factory :question do
    title "Simple title"
    body "Placeholder for body"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
