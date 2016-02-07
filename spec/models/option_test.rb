require 'rails_helper'

describe Option do

  it 'has a valid factory' do
    expect(build(:option)).to be_present
  end

  context "<< class methods" do
    let(:value) { Option.create(symbol: "A160219C00020000", option_type: "call", strike: "20.0", expiration_date: "2016-02-19", stock_id: "1") }

    it { expect(Option).to respond_to(:find_or_create)   }
    it { expect(Option).to respond_to(:find_by_id)       }
    it { expect(Option).to respond_to(:find_by_symbol)   }

    it { expect(Option.find_by_id(value.id)).to         eq(value) }
    it { expect(Option.find_by_symbol(value.symbol)).to eq(value) }
  end

  context "<< attributes" do
    it { should respond_to(:id)                 }
    it { should respond_to(:symbol)             }
    it { should respond_to(:description)        }
    it { should respond_to(:option_type)        }
    it { should respond_to(:exch)               }
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
    it { should respond_to(:price_spread)       }
    it { should respond_to(:bid_price)          }
    it { should respond_to(:bid_size)           }
    it { should respond_to(:bid_exch)           }
    it { should respond_to(:bid_date)           }
    it { should respond_to(:ask_price)          }
    it { should respond_to(:ask_size)           }
    it { should respond_to(:ask_exch)           }
    it { should respond_to(:ask_date)           }
    it { should respond_to(:open_interest)      }
    it { should respond_to(:underlying)         }
    it { should respond_to(:strike)             }
    it { should respond_to(:contract_size)      }
    it { should respond_to(:expiration_date)    }
    it { should respond_to(:expiration_type)    }
    it { should respond_to(:days_to_expiration) }
  end

  context "<< methods" do
    it { should respond_to(:stock)              }
    it { should respond_to(:quote=)             }
  end

end
