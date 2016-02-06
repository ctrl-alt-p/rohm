class Api::V1::StockResource < JSONAPI::Resource
  attribute :symbol,            format: :string  # Symbol
  attribute :description,       format: :string  # Symbol description
  attribute :security_type,     format: :string  # Type of security (i.e. stock, etf, option, index)
  attribute :change_price,      format: :float   # Daily net change
  attribute :change_percentage, format: :float   # Daily net change
  attribute :volume,            format: :integer # Volume for the day
  attribute :average_volume,    format: :integer # Average daily volume
  attribute :last_price,        format: :float   # Last incremental price
  attribute :last_volume,       format: :integer # Last incremental volume
  attribute :last_trade_date,   format: :date    # Date and time of last trade
  attribute :open,              format: :float   # Opening price
  attribute :high,              format: :float   # Trading day high
  attribute :low,               format: :float   # Trading day low
  attribute :close,             format: :float   # Closing price
  attribute :prev_close,        format: :float   # Previous closing price
  attribute :week_52_high,      format: :float   # 52 week high
  attribute :week_52_low,       format: :float   # 52 week low
  attribute :bid_price,         format: :float   # Current bid
  attribute :bid_size,          format: :integer # Size of bid
  attribute :bid_exch,          format: :string  # Exchange of bid
  attribute :bid_date,          format: :date    # Date and time of current bid
  attribute :ask_price,         format: :float   # Current ask
  attribute :ask_size,          format: :integer # Size of ask
  attribute :ask_exch,          format: :string  # Exchange of ask
  attribute :ask_date,          format: :date    # Date and time of current ask

  # Objects we own:
  has_many :options

  # Collection lookup
  def self.records options = {}
    case
    when options[:symbol].present?
      Stock.find_by_symbol(options[:symbol])
    when options[:id].present?
      Stock.find(options[:id])
    else
      Stock.all
    end
  end
end
