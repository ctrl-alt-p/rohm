require_relative '../models/concerns/executed_in_seconds'
require 'yaml'

module ExchangeHelper

  # Seed data for the exchanges
  class SeedData
    include ExecutedInSeconds
    attr_reader :exchange_data
    attr_reader :exchanges

    def initialize
      @exchange_data = YAML.load_file(Rails.root.join('db/seed_exchanges.yml'))
      @exchanges     = []
    end

    # Find/Create the exchanges from the opts hash above:
    def seed_data!
      log_run_time "Purging Exchanges" do
        Exchange.all.map(&:delete)
      end

      @exchanges = log_run_time "Building Exchanges" do
        @exchange_data.map { |hash| Exchange.create(hash).reload_symbols! }
      end

      self
    end
  end

end
