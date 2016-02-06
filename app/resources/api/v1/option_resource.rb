class Api::V1::OptionResource < JSONAPI::Resource
  attribute :symbol,             format: :string  # Option Symbol
  attribute :description,        format: :string  # Symbol description
  attribute :option_type,        format: :string  # Type of option (Call or Put)
  attribute :exch,               format: :string  # Exchange
  attribute :change_price,       format: :float   # Daily net change
  attribute :change_percentage,  format: :float   # Daily net change
  attribute :volume,             format: :integer # Volume for the day
  attribute :average_volume,     format: :integer # Average daily volume
  attribute :last_price,         format: :float   # Last incremental volume
  attribute :last_volume,        format: :integer # Last incremental volume
  attribute :last_trade_date,    format: :date    # Date and time of last trade
  attribute :open_price,         format: :float   # Opening price
  attribute :high_price,         format: :float   # Trading day high
  attribute :low_price,          format: :float   # Trading day low
  attribute :close_price,        format: :float   # Closing price
  attribute :prev_close_price,   format: :float   # Previous closing price
  attribute :price_spread,       format: :float   # Bid/Ask spread
  attribute :bid_price,          format: :float   # Current bid
  attribute :bid_size,           format: :integer # Size of bid
  attribute :bid_exch,           format: :integer # Exchange of bid
  attribute :bid_date,           format: :date    # Date and time of current bid
  attribute :ask_price,          format: :float   # Current ask
  attribute :ask_size,           format: :integer # Size of ask
  attribute :ask_exch,           format: :integer # Exchange of ask
  attribute :ask_date,           format: :date    # Date and time of current ask
  attribute :open_interest,      format: :integer # Open interest
  attribute :underlying,         format: :string  # Underlying symbol
  attribute :strike,             format: :float   # Strike price
  attribute :contract_size,      format: :integer # Size of the contract in shares
  attribute :expiration_date,    format: :date    # Date of expiration
  attribute :expiration_type,    format: :string  # Type of expiration (standard, weekly)
  attribute :days_to_expiration, format: :integer # Number of days until it expires

  # Collection lookup
  def self.records options = {}
    case
    when options[:symbol].present?
      Option.find_by_symbol(options[:symbol])
    when options[:id].present?
      Option.find(options[:id])
    else
      Option.all
    end
  end
end
