class Option < Ohm::Model
  # We are owned by a Stock
  reference :stock, :Stock

  # Attributes of our model
  attribute :code
  attribute :expiration_date
  attribute :days_to_expiration
  attribute :strike_price
  attribute :bid_price
  attribute :ask_price
  attribute :delta_price
  attribute :volume
  attribute :open_interest

  unique :code
  index  :code
  index  :expiration_date
  index  :days_to_expiration
  index  :strike_price
  index  :delta_price
end
