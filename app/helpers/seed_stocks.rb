class SeedStocks
  include ExecutedInSeconds
  attr_reader :stocks

  def initialize
    log_run_time "Loading Stocks" do
      @stock_ids = $redis.hgetall('Stock:uniques:symbol').values.map(&:to_i).shuffle
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed! progressbar
    progressbar.stop
    progressbar.reset
    progressbar.title = 'Building Stocks'
    progressbar.total = @stock_ids.count
    progressbar.start
    progressbar.log progressbar.title

    log_run_time "Seeding Stocks" do
      @stock_ids.in_groups_of(1000).map(&:compact).each do |stock_ids|
        stocks = stock_ids.map { |id| Stock[id] }
        Quote.fetch_data! stocks

        # Individually fetch any stocks that failed the first time around
        stocks.select! { |stock| stock.description.blank? }
        stocks.each do |stock|
          Quote.fetch_data!([stock], true)
        end

        progressbar.progress = progressbar.progress + stocks.count
      end
    end
    progressbar.finish

    progressbar.title = 'Building Stock Options'
    progressbar.progress = 0
    progressbar.start
    progressbar.log progressbar.title
    log_run_time "Seeding Stock Options" do
      Parallel.each(@stock_ids, in_processes: 4, finish: ->(item, i, result) { progressbar.increment }) do |id|
        # Re-connect
        Ohm.redis = Redic.new("redis://127.0.0.1:6379")
        Stock[id].refresh_options!
        nil
      end
    end
    progressbar.finish

    self
  end
end
