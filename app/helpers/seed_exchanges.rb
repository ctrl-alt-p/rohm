require 'yaml'

class SeedExchanges
  include ExecutedInSeconds
  attr_reader :exchange_data
  attr_reader :exchanges

  def initialize
    log_run_time "Loading Exchanges" do
      @exchange_data = YAML.load_file(Rails.root.join('db/seed_exchanges.yml'))
      @exchanges     = @exchange_data.map { |hash| Exchange.find_or_create(hash[:slug], hash) }
    end
  end

  # Find/Create the exchanges from the opts hash above:
  def seed! progressbar
    progressbar.stop
    progressbar.reset
    progressbar.title = 'Building Exchanges'
    progressbar.total = @exchanges.count
    progressbar.start
    progressbar.log progressbar.title

    log_run_time "Building Exchanges" do
      @exchanges.each do |exchange|
        progressbar.increment
        exchange.reload_data!
      end
    end

    progressbar.finish
    self
  end
end
