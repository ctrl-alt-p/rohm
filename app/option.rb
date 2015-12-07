class Option < Ohm::Model
  # We are owned by a Stock
  reference :stock, :Stock

  # Attributes of our model
  attribute :id
  attribute :expiration_date
  attribute :days_to_expiration
  attribute :strike_price
  attribute :bid_price
  attribute :ask_price
  attribute :delta_price
  attribute :volume
  attribute :open_interest

  # Index lookups:
  index     :id

end
