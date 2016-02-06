class DateValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value)
      return Time.at(raw_value.to_i/1000).to_s unless raw_value.to_s.blank?
      nil
    end
  end
end
