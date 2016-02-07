# spec/factories/stocks.rb
FactoryGirl.define do
  factory :option do
    symbol              { Faker::Name.name         } # Option Symbol
    description         { Faker::Name.name         } # Symbol description
    option_type         { 'call'                   } # Type of option (Call or Put)
    exch                { 'A'                      } # Exchange
    change_price        { Faker::Number.decimal(2) } # Daily net change
    change_percentage   { Faker::Number.decimal(2) } # Daily net change
    volume              { Faker::Number.number(10) } # Volume for the day
    average_volume      { Faker::Number.number(10) } # Average daily volume
    last_price          { Faker::Number.decimal(2) } # Last incremental price
    last_volume         { Faker::Number.number(10) } # Last incremental volume
    last_trade_date     { Faker::Number.number(10) } # Date and time of last trade
    open_price          { Faker::Number.decimal(2) } # Opening price
    high_price          { Faker::Number.decimal(2) } # Trading day high
    low_price           { Faker::Number.decimal(2) } # Trading day low
    close_price         { Faker::Number.decimal(2) } # Closing price
    prev_close_price    { Faker::Number.decimal(2) } # Previous closing price
    price_spread        { Faker::Number.decimal(2) } # Bid/Ask spread
    bid_price           { Faker::Number.decimal(2) } # Current bid
    bid_size            { Faker::Number.number(10) } # Size of bid
    bid_exch            { 'A'                      } # Exchange of bid
    bid_date            { Faker::Number.number(10) } # Date and time of current bid
    ask_price           { Faker::Number.decimal(2) } # Current ask
    ask_size            { Faker::Number.number(10) } # Size of ask
    ask_exch            { 'A'                      } # Exchange of ask
    ask_date            { Faker::Number.number(10) } # Date and time of current ask
    open_interest       { Faker::Number.number(10) } # Open interest
    underlying          { Faker::Name.name         } # Underlying symbol
    strike              { Faker::Number.decimal(2) } # Strike price
    contract_size       { 100                      } # Size of the contract in shares
    expiration_date     { Faker::Number.number(10) } # Date of expiration
    expiration_type     { 'standard'               } # Type of expiration (standard, weekly)
    days_to_expiration  { Faker::Number.number(10) } # Number of days until it expires
  end
end
