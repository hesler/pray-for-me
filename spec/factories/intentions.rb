require 'faker'

FactoryGirl.define do
  factory :intention, class: Intention do
    content { Faker::Lorem.paragraph(1) }
    city { Faker::Address.city }
    region { Faker::Address.state }
    country { Faker::Address.country }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end
