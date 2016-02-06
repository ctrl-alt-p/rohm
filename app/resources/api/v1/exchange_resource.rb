class Api::V1::ExchangeResource < JSONAPI::Resource
  # Attributes of our model
  attribute :slug,     format: :string
  attribute :exchange, format: :string
  attribute :name,     format: :string

  # Objects we own:
  has_many :stocks

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
