class IntegerValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value)
      return raw_value.to_i unless raw_value.to_s.blank?
      nil
    end
  end
end
