class Api::V1::ExchangeResource < JSONAPI::Resource
  # Attributes of our model
  attributes :slug, :exchange, :name,  :url

  # Objects we own:
  # has_many :stocks, :ExchangeToStock


  # Collection lookup
  def self.records options = {}
    case
    when options[:slug].present?
      Exchange.find_by_slug(options[:slug])
    when options[:id].present?
      Exchange.find(options[:id])
    else
      Exchange.all
    end
  end
end
