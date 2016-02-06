# config/initializers/ohm.rb

# Configure our connections:
Ohm.redis = Redic.new("redis://127.0.0.1:6379")

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
