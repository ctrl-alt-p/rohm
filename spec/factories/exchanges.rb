# spec/factories/exchanges.rb
FactoryGirl.define do
  factory :exchange do
    # Attributes of our model
    slug     { Faker::Name.color.upcase }
    exchange { Faker::Name.color.upcase }
    name     { Faker::Name.name         }
    url      { Faker::Internet.url      }
    symbols  { 20.times.map{ Faker::Name.color.upcase } }
  end
end
