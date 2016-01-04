class Stock < Ohm::Model
  # Attributes of our model
  attribute :symbol
  attribute :name
  attribute :description
  attribute :last
  attribute :change
  attribute :change_percentage
  attribute :volume
  attribute :average_volume
  attribute :last_volume
  attribute :trade_date
  attribute :open
  attribute :high
  attribute :low
  attribute :close
  attribute :prev_close
  attribute :week_52_high
  attribute :week_52_low
  attribute :bid
  attribute :bid_size
  attribute :bid_date
  attribute :ask
  attribute :ask_size
  attribute :ask_date

  # Objects we own:
  collection :exchange_to_stocks, :ExchangeToStock
  collection :options, :Option

  # Index lookups:
  unique    :symbol
  index     :symbol

  def reload_quotes!
    StockHelper::SeedData.new.fetch_quotes!([self])
  end

end
