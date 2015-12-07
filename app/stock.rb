class Stock < Ohm::Model
  # Attributes of our model
  attribute :id
  attribute :name
  attribute :exchange
  attribute :bid_price
  attribute :ask_price
  attribute :delta_price
  attribute :volume

  # Objects we own:
  collection :options, :Option

  # Index lookups:
  index     :id

  # Alias symbol to id
  def symbol; id; end

end
