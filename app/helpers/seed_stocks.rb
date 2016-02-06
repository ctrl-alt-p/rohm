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
        progressbar.progress = progressbar.progress + stocks.count
      end
    end
    progressbar.finish

    progressbar.title = 'Building Stock Options'
    progressbar.progress = 0
    progressbar.start
    progressbar.log progressbar.title
    log_run_time "Seeding Stock Options" do
      @stocks.each do |stock|
        stock.refresh_options!
        progressbar.progress = progressbar.progress + 1
      end
    end
    progressbar.finish

    self
  end
end
