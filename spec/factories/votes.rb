FactoryGirl.define do
  factory :vote do
    author
    value 1
    votable { |obj| obj.association(:question) }
  end
end
