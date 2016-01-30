class SeedStocks
  include ExecutedInSeconds
  attr_reader :stocks

  def initialize
    log_run_time "Loading Stocks" do
      @stocks = Stock.all.to_a.sort_by(&:symbol)
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed!
    log_run_time "Seeding Stocks" do
      progressbar = ProgressBar.create( :format         => '%E | %a %bᗧ%i %p%% %t',
                                        :progress_mark  => ' ',
                                        :remainder_mark => '･',
                                        :starting_at    => 0,
                                        :total          => @stocks.count+2,
                                        :title          => 'Building Stocks',
                                        )
      progressbar.start

      Quote.fetch_data! @stocks
      progressbar.increment

      @stocks.each do |stock|
        stock.refresh_options!
        progressbar.increment
      end

      progressbar.finish
    end

    self
  end
end
