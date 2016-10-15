FactoryGirl.define do
  factory :answer do
    body 'Answer placeholder'
    question_id 1
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
