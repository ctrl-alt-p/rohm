class Exchange < Ohm::Model
  # Attributes of our model
  attribute :slug
  attribute :exchange
  attribute :name
  attribute :url
  attribute :symbols

  # Index lookups:
  unique    :slug
  index     :slug

  def populate_stocks
    response    = Faraday.get(url)
    rows        = response.body.split("\n")[1..-1].inject({}) do |hash, line|
      pieces    = line.split(',')
      symbol    = pieces[0]
      name      = pieces[1..-3].join(',')
      hash[symbol] = name
      hash
    end

    self.symbols = rows.keys
    self.save
    Rails.logger.debug { "Generated exchange: #{self.inspect}" }

    rows.each do |symbol, name|
      stock           = Stock.with(:symbol, symbol) || Stock.create(symbol: symbol)
      stock.name      = name
      stock.exchanges ||= []
      stock.exchanges << exchange
      stock.save
      Rails.logger.debug { "Generated stock: #{stock.inspect}" }
      stock
    end
  end
end
