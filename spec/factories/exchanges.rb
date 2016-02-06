# spec/factories/exchanges.rb
FactoryGirl.define do
  factory :exchange do
    # Attributes of our model
    slug     { Faker::Internet.slug.upcase    }
    exchange { Faker::Name.name               }
    name     { Faker::Name.name               }
    url      { Faker::Internet.url            }
  end
end
