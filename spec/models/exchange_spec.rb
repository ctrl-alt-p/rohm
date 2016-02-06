require 'rails_helper'

describe Exchange do

  it 'has a valid factory' do
    expect(build(:exchange)).to be_present
  end

  context "<< class methods" do
    let(:value) { Exchange.create(slug: Faker::Internet.slug.upcase, exchange: Faker::Name.name, name: Faker::Name.name, url: Faker::Internet.url) }

    it { expect(Exchange).to respond_to(:find_or_create)   }
    it { expect(Exchange).to respond_to(:find_by_id)       }
    it { expect(Exchange).to respond_to(:find_by_slug)     }

    it { expect(Exchange.find_by_id(value.id)).to     eq(value) }
    it { expect(Exchange.find_by_slug(value.slug)).to eq(value) }
  end

  context "<< attributes" do
    it { should respond_to(:id)                 }
    it { should respond_to(:slug)               }
    it { should respond_to(:exchange)           }
    it { should respond_to(:name)               }
    it { should respond_to(:url)                }
    it { should respond_to(:exchange_to_stocks) }
  end

  context "<< methods" do
    it { should respond_to(:stocks)             }
    it { should respond_to(:stock_ids)          }
    it { should respond_to(:stock_ids=)         }
    it { should respond_to(:stock_symbols)      }
    it { should respond_to(:stock_symbols=)     }
    it { should respond_to(:reload_data!)       }
  end

end
