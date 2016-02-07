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
        Quote.fetch_data! options
        nil
      end
    end

    progressbar.finish
    self
  end
end
