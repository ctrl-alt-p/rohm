class Stock < Ohm::Model
  # Attributes of our model
  attribute :symbol
  attribute :name
  attribute :exchanges
  attribute :bid_price
  attribute :ask_price
  attribute :delta_price
  attribute :volume

  # Objects we own:
  collection :options, :Option

  # Index lookups:
  unique    :symbol
  index     :symbol
end
