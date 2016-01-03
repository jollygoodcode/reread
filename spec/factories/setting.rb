# This will guess the User class
FactoryGirl.define do
  factory :setting do
    email       { Faker::Internet.email }
    time_zone   'Singapore'
    send_at     '11:00'
    schedule    'everyday'
    number      1
    state       'unread'
    age_months  0
    redirect_to :pocket_url
    archive     true
  end
end
