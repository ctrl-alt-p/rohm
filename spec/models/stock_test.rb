require 'rails_helper'

describe Stock do

  it 'has a valid factory' do
    expect(build(:stock)).to be_present
  end

  context "<< class methods" do
    let(:value) { Stock.create(symbol: "A", description: "Agilent Technologies Inc", security_type: "stock", change_price: "-1.3900000000000001", change_percentage: "-3.7199999999999998", volume: "4424609", average_volume: "3027345", last_volume: "200542", last_trade_date: "1454706150000", open_price: "37.26", high_price: "37.31", low_price: "35.83", close_price: "36.04", prev_close_price: "37.42", week_52_high: "43.59", week_52_low: "33.115", bid_price: "35.01", bid_size: "2", bid_exch: "Q", bid_date: "1454718531000", ask_price: "39.0", ask_size: "0", ask_exch: "K", ask_date: "1454720400000") }

    it { expect(Stock).to respond_to(:find_or_create)   }
    it { expect(Stock).to respond_to(:find_by_id)       }
    it { expect(Stock).to respond_to(:find_by_symbol)   }

    it { expect(Stock.find_by_id(value.id)).to         eq(value) }
    it { expect(Stock.find_by_symbol(value.symbol)).to eq(value) }
  end

  context "<< attributes" do
    it { should respond_to(:id)                 }
    it { should respond_to(:symbol)             }
    it { should respond_to(:description)        }
    it { should respond_to(:security_type)      }
    it { should respond_to(:change_price)       }
    it { should respond_to(:change_percentage)  }
    it { should respond_to(:volume)             }
    it { should respond_to(:average_volume)     }
    it { should respond_to(:last_price)         }
    it { should respond_to(:last_volume)        }
    it { should respond_to(:last_trade_date)    }
    it { should respond_to(:open_price)         }
    it { should respond_to(:high_price)         }
    it { should respond_to(:low_price)          }
    it { should respond_to(:close_price)        }
    it { should respond_to(:prev_close_price)   }
    it { should respond_to(:week_52_high)       }
    it { should respond_to(:week_52_low)        }
    it { should respond_to(:bid_price)          }
    it { should respond_to(:bid_size)           }
    it { should respond_to(:bid_exch)           }
    it { should respond_to(:bid_date)           }
    it { should respond_to(:ask_price)          }
    it { should respond_to(:ask_size)           }
    it { should respond_to(:ask_exch)           }
    it { should respond_to(:ask_date)           }
  end

  context "<< methods" do
    it { should respond_to(:exchange_to_stocks) }
    it { should respond_to(:options)            }
    it { should respond_to(:refresh_data!)      }
    it { should respond_to(:refresh_options!)   }
    it { should respond_to(:quote=)             }
  end

end
