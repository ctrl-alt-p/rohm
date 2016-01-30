class ExchangeToStock < Ohm::Model
  reference :exchange, :Exchange
  reference :stock,    :Stock

  delegate :symbol, to: :stock, allow_nil: true, prefix: true
end
