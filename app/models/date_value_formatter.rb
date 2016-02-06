class DateValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value)
      return nil if raw_value.to_s.blank?
      return Time.at(raw_value.to_i/1000).to_s if raw_value.to_i.to_s == raw_value.to_s
      Time.parse(raw_value).to_s
    end
  end
end
