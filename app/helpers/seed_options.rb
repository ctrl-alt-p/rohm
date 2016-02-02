class SeedOptions
  include ExecutedInSeconds
  attr_reader :options

  def initialize
    log_run_time "Loading Options" do
      @options = Option.all.to_a.sort_by(&:symbol)
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed! progressbar
    progressbar.stop
    progressbar.reset
    progressbar.title = 'Building Options'
    progressbar.total = @options.count
    progressbar.start
    progressbar.log progressbar.title

    log_run_time "Seeding Options" do
      @options.in_groups_of(1000).map(&:compact).each do |options|
        Quote.fetch_data! options
        progressbar.progress = progressbar.progress + options.count
      end
    end

    progressbar.finish
    self
  end
end
