module ExecutedInSeconds

  def log_run_time block_name, &block
    result = nil
    time   = Benchmark.realtime { result = yield }
    Rails.logger.tagged(*([self.class.to_s, try(:id)].compact)) { |logger| logger.info "#{block_name}=#{time}s" }
    result
  end


  def self.log_run_time block_name, &block
    result = nil
    time   = Benchmark.realtime { result = yield }
    Rails.logger.tagged(self.class.to_s) { |logger| logger.info "#{block_name}=#{time}s" }
    result
  end

end
