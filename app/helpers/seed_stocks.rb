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
      Parallel.each(stocks, in_processes: 4, finish: ->(item, i, result) { progressbar.increment }) do |stock|
        # Re-connect
        Ohm.redis = Redic.new("redis://127.0.0.1:6379")
        stock.refresh_options!
        nil
      end
    end
    progressbar.finish

    self
  end
end
