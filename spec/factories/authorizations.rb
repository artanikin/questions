FactoryGirl.define do
  factory :authorization do
    user
    provider "MyString"
    uid "MyString"
  end
end
