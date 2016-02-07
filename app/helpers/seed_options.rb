class SeedOptions
  include ExecutedInSeconds
  attr_reader :options

  def initialize
    log_run_time "Loading Options" do
      @option_ids = $redis.hgetall('Option:uniques:symbol').values.map(&:to_i).shuffle
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed! progressbar
    grouped_ids = @option_ids.in_groups_of(1000).map(&:compact)
    progressbar.stop
    progressbar.reset
    progressbar.title = 'Building Options'
    progressbar.total = grouped_ids.count
    progressbar.start
    progressbar.log progressbar.title

    log_run_time "Seeding Options" do
      Parallel.each(grouped_ids, in_processes: 4, finish: ->(item, i, result) { progressbar.increment }) do |option_ids|
        options = option_ids.map { |id| Option[id] }
        results = Quote.fetch_data! options

        # Individually fetch any options that failed the first time around
        if results[:misses].present?
          progressbar.log "Re-trying options.symbol=#{results[:misses]}"
          options.select! { |option| results[:misses].include?(option.symbol) }
          options.each do |option|
            results = Quote.fetch_data!([option], true)
            progressbar.log("Failed to fetch quote for option.symbol=#{option.symbol}") if results[:misses].include? option.symbol
          end
        end

        nil
      end
    end

    progressbar.finish
    self
  end
end
