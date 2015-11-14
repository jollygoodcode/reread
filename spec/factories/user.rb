# This will guess the User class
FactoryGirl.define do
  factory :user do
    username  { Faker::Internet.user_name }
    token     { Faker::Number.hexadecimal(10) }
  end
end
