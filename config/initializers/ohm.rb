# config/initializers/ohm.rb

# Configure our connections:
Ohm.redis = Redic.new("redis://127.0.0.1:6379")
$redis    = Redis.new(:driver => :hiredis)

class Ohm::Model
  def self.find_by_id(id)
    self[id]
  end

  def self.unique(attribute)
    uniques << attribute unless uniques.include?(attribute)

    # Create a AR helper "find_by_<field>"
    self.define_singleton_method("find_by_#{attribute}") do |value|
      self.with(attribute, value)
    end
  end
end

class Ohm::Set
  def order order_options
    self
  end

  def where options
    case
    when options.blank?
      return @model.all
    when options.count == 1
      key   = options.keys.first
      value = options.values.first
      return [@model.send("find_by_#{key}", value)]
    else
      return @model.find(options)
    end
  end
end

class Array
  def order order_options
    self
  end
end
