module RetryRequest
  def self.retry_request &block
    5.times do
      begin
        output = yield
        return output
      rescue Tradier::Error::BadRequest => e
        raise e unless e.message.include?('Quota Violation: Expires ')
        # byebug

        start_time = e.message.split('Quota Violation: Expires ').last.to_i / 1000
        time_delta = (Time.now.to_i - start_time).abs + 1
        puts "\n\n[#{start_time}] Sleeping #{time_delta}s...\n\n"
        sleep time_delta
      rescue NoMethodError => e # undefined method `[]' for nil:NilClass
        puts e.message
        puts (e.backtrace || []).join("\n")
        return []
      end
    end
  end
end
