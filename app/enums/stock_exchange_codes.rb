class StockExchangeCodes < ClassyEnum::Base
  def name; "Stock Exchanges"; end
end

class StockExchangeCodes::A < StockExchangeCodes; def name; "NYSE MKT (ex-AMEX)"; end; end
class StockExchangeCodes::B < StockExchangeCodes; def name; "NASDAQ OMX BX"; end; end
class StockExchangeCodes::C < StockExchangeCodes; def name; "National Stock Exchange"; end; end
class StockExchangeCodes::D < StockExchangeCodes; def name; "FINRA"; end; end
class StockExchangeCodes::F < StockExchangeCodes; def name; "Mutual Funds/Money Markets (NASDAQ)"; end; end
class StockExchangeCodes::I < StockExchangeCodes; def name; "International Securities Exchange"; end; end
class StockExchangeCodes::J < StockExchangeCodes; def name; "Direct Edge A"; end; end
class StockExchangeCodes::K < StockExchangeCodes; def name; "Direct Edge X"; end; end
class StockExchangeCodes::M < StockExchangeCodes; def name; "Chicago Stock Exchange"; end; end
class StockExchangeCodes::N < StockExchangeCodes; def name; "NYSE"; end; end
class StockExchangeCodes::P < StockExchangeCodes; def name; "NYSE ArcaSM"; end; end
class StockExchangeCodes::Q < StockExchangeCodes; def name; "NASDAQ OMX"; end; end
class StockExchangeCodes::S < StockExchangeCodes; def name; "NASDAQ Small Cap"; end; end
class StockExchangeCodes::T < StockExchangeCodes; def name; "NASDAQ Int"; end; end
class StockExchangeCodes::U < StockExchangeCodes; def name; "OTCBB"; end; end
class StockExchangeCodes::V < StockExchangeCodes; def name; "OTC other"; end; end
class StockExchangeCodes::W < StockExchangeCodes; def name; "CBOE"; end; end
class StockExchangeCodes::X < StockExchangeCodes; def name; "NASDAQ OMX PSX"; end; end
class StockExchangeCodes::G < StockExchangeCodes; def name; "GLOBEX"; end; end
class StockExchangeCodes::Y < StockExchangeCodes; def name; "BATS Y-Exchange"; end; end
class StockExchangeCodes::Z < StockExchangeCodes; def name; "BATS"; end; end
