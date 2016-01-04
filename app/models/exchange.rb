class Exchange < Ohm::Model
  # Attributes of our model
  attribute :slug
  attribute :exchange
  attribute :name
  attribute :url
  attribute :symbols_json

  # Objects we own:
  collection :exchange_to_stocks, :ExchangeToStock

  # Index lookups:
  unique    :slug
  index     :slug


  def stock_ids
    exchange_to_stocks.map(&:stock_id)
  end

  # Get serialized attribute :symbols_json
  def symbols
    return JSON.parse(symbols_json) if symbols_json.present?
    []
  end

  # Set serialized attribute :symbols_json
  def symbols=(values)
    symbols_json = values.present? ? values.to_json : nil
    symbols_json
  end


  # Load the symbols from the CSV url
  def reload_symbols!
    # Fetch the CSV if stocks
    # - Parse the SYMBOL & NAME from the CSV
    # - Find/Create the stock for each row in the CSV
    _stocks = Faraday.get(url).body.split("\n")[1..-1].map do |line|
      symbol = line.split(',').first.strip
      name   = line.split(',')[1..-3].join(',')
      stock  = Stock.with(:symbol, symbol) || Stock.new(symbol: symbol)
      stock.update(name: name) if stock.name != name
      stock
    end
    new_stock_ids     = _stocks.map(&:id) - stock_ids
    removed_stock_ids = stock_ids         - _stocks.map(&:id)

    # Remove the stocks from the exchange that no longer apply
    exchange_to_stocks.to_a.select { |value| removed_stock_ids.include?(value.stock_id) }.map(&:destroy)

    # Add the stocks from the exchange that are new
    exchange_to_stocks.to_a.select { |value| new_stock_ids.include?(value.stock_id) }.each { |stock_id| ExchangeToStock.create(exchange_id: id, stock_id: stock_id) }

    # Update / Save the symbols list on the model
    self.symbols=_stocks.map(&:symbol)
    self.save

    self
  end
end
