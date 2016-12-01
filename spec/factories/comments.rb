FactoryGirl.define do
  factory :comment do
    body "This is placeholder for comment"
    commentable { |obj| obj.association(:question) }
    author
  end
end
