class SeedStocks
  include ExecutedInSeconds
  attr_reader :stocks

  def initialize
    log_run_time "Loading Stocks" do
      @stocks = Stock.all.to_a.sort_by(&:symbol)
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed! progressbar
    progressbar.stop
    progressbar.reset
    progressbar.title = 'Building Stocks'
    progressbar.total = @stocks.count
    progressbar.start
    progressbar.log progressbar.title

    log_run_time "Seeding Stocks" do
      @stocks.in_groups_of(1000).map(&:compact).each do |stocks|
        Quote.fetch_data! stocks
        stocks.map(&:refresh_options!)
        progressbar.progress = progressbar.progress + stocks.count
      end
    end

    progressbar.finish
    self
  end
end
