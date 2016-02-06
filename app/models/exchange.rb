class Exchange < Ohm::Model
  # Attributes of our model
  attribute :slug
  attribute :exchange
  attribute :name
  attribute :url

  # Objects we own:
  collection :exchange_to_stocks, :ExchangeToStock


  # Index lookups:
  unique    :slug
  index     :slug

  def self.find_or_create slug, opts
    Exchange.find_by_slug(slug) || Exchange.create(slug: slug, exchange: opts[:exchange], url: opts[:url], name: opts[:name])
  end

  def stocks
    Stock.fetch(stock_ids)
  end

  def stock_ids
    exchange_to_stocks.map(&:stock_id).compact
  end

  def stock_ids= ids
    exchange_to_stocks.map(&:delete)
    ids.each { |stock_id| ExchangeToStock.create(exchange_id: id, stock_id: stock_id) }
    self
  end

  def stock_symbols
    exchange_to_stocks.map(&:stock_symbol).compact
  end

  def stock_symbols= symbols
    self.stock_ids= symbols.map { |symbol| Stock.find_or_create(symbol) }.map(&:id)
    self
  end

  # Load the symbols from the CSV url
  def reload_data!
    # Fetch the CSV if stocks
    # - Parse the SYMBOL & NAME from the CSV
    # - Find/Create the stock for each row in the CSV
    self.stock_symbols = Faraday.get(url).body.split("\n")[1..-1].map { |line| line.split(',').first.strip }.select(&:present?).sort
    self
  end
end
