class Stock < Ohm::Model
  # Attributes of our model
  attribute :symbol
  attribute :name
  attribute :description
  attribute :exchanges
  attribute :last_price
  attribute :bid_price
  attribute :ask_price
  attribute :delta_price
  attribute :volume

  # Objects we own:
  collection :options, :Option

  # Index lookups:
  unique    :symbol
  index     :symbol



  # Load the stocks from the known exchanges
  def self.load_stocks
    symbols = Exchange.load_exchanges.map(&:symbols).join(',').split(',').uniq
    quotes  = symbols.in_groups_of(500, nil).map(&:compact).map { |group| TradierClient.instance.client.quotes group.join(',') }.flatten.compact

    quotes.map do |quote|
      stock = Stock.with(:symbol, quote.symbol) || Stock.create(symbol: quote.symbol)

      # Working on mapping A -> B
      {
        description: :description,
        last:        :last_price,
      }

      # Sample JSON payload from Tradier:
      #
      #          :symbol => "SMIN",
      #       :description => nil,
      #              :exch => nil,
      #              :type => nil,
      #              :last => nil,
      #            :change => nil,
      # :change_percentage => nil,
      #            :volume => 0,
      #    :average_volume => 21082,
      #       :last_volume => 0,
      #        :trade_date => 0,
      #              :open => nil,
      #              :high => nil,
      #               :low => nil,
      #             :close => nil,
      #         :prevclose => "NaN",
      #      :week_52_high => 37.95,
      #       :week_52_low => 28.6,
      #               :bid => nil,
      #           :bidsize => 0,
      #           :bidexch => nil,
      #          :bid_date => 0,
      #               :ask => nil,
      #           :asksize => 0,
      #           :askexch => nil,
      #          :ask_date => 0


      stock.update(
        symbol:    symbol,
        name:      name,
        exchanges: [stock.exchanges.to_s.split(','), exchange].flatten.join(','),
      )

      Rails.logger.debug { "Loaded Stock: slug=#{stock.symbol}, name=#{stock.name}" }
      stock
    end
  end


end
