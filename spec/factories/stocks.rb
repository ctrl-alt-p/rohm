# spec/factories/stocks.rb
FactoryGirl.define do
  factory :stock do
    # Attributes of our model
    symbol       { Faker::Commerce.color.upcase }
    name         { Faker::Name.name }
    exchanges    { 3.times.map { Faker::Commerce.color.upcase } }
    bid_price    { Faker::Number.decimal(2) }
    ask_price    { Faker::Number.decimal(2) }
    delta_price  { Faker::Number.decimal(2) }
    volume       { Faker::Number.number(10) }
  end
end
