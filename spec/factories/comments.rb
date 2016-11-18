FactoryGirl.define do
  factory :comment do
    body "MyText"
    commentable nil
    author nil
  end
end
