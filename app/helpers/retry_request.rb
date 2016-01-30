module RetryRequest
  def self.retry_request &block
    3.times do
      begin
        output = yield
        return output
      rescue Tradier::Error::BadRequest => e
        raise e unless e.message.include?('Quota Violation: Expires ')
        sleep 61
      rescue NoMethodError => e # undefined method `[]' for nil:NilClass
        puts e.message
        puts (e.backtrace || []).join("\n")
        return []
      end
    end
  end
end
