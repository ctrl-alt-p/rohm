class ExchangeToStock < Ohm::Model
  reference :exchange, :Exchange
  reference :stock,    :Stock
end
