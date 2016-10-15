FactoryGirl.define do
  factory :answer do
    question
    body 'Answer placeholder'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
