# spec/factories/stocks.rb
FactoryGirl.define do
  factory :stock do
    symbol            { Faker::Name.name         } # Symbol
    description       { Faker::Name.name         } # Symbol description
    security_type     { Faker::Name.name         } # Type of security (i.e. stock, etf, option, index)
    change_price      { Faker::Number.decimal(2) } # Daily net change
    change_percentage { Faker::Number.decimal(2) } # Daily net change
    volume            { Faker::Number.number(10) } # Volume for the day
    average_volume    { Faker::Number.number(10) } # Average daily volume
    last_price        { Faker::Number.decimal(2) } # Last incremental price
    last_volume       { Faker::Number.number(10) } # Last incremental volume
    last_trade_date   { Faker::Number.number(10) } # Date and time of last trade
    open_price        { Faker::Number.decimal(2) } # Opening price
    high_price        { Faker::Number.decimal(2) } # Trading day high
    low_price         { Faker::Number.decimal(2) } # Trading day low
    close_price       { Faker::Number.decimal(2) } # Closing price
    prev_close_price  { Faker::Number.decimal(2) } # Previous closing price
    week_52_high      { Faker::Number.decimal(2) } # 52 week high
    week_52_low       { Faker::Number.decimal(2) } # 52 week low
    bid_price         { Faker::Number.decimal(2) } # Current bid
    bid_size          { Faker::Number.number(10) } # Size of bid
    bid_exch          { 'A'                      } # Exchange of bid
    bid_date          { Faker::Number.number(10) } # Date and time of current bid
    ask_price         { Faker::Number.decimal(2) } # Current ask
    ask_size          { Faker::Number.number(10) } # Size of ask
    ask_exch          { 'A'                      } # Exchange of ask
    ask_date          { Faker::Number.number(10) } # Date and time of current ask
  end
end
