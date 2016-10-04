FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password { Faker::Internet.password(10) }
  end
end
