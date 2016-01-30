class OptionExchangeCodes < ClassyEnum::Base
  def name; "OPRA Feeds (Options)"; end
end

class OptionExchangeCodes::A < OptionExchangeCodes; def name; "NYSE MKT (ex-AMEX)"; end; end
class OptionExchangeCodes::B < OptionExchangeCodes; def name; "NASDAQ OMX BX"; end; end
class OptionExchangeCodes::C < OptionExchangeCodes; def name; "CBOE"; end; end
class OptionExchangeCodes::I < OptionExchangeCodes; def name; "ISE"; end; end
class OptionExchangeCodes::M < OptionExchangeCodes; def name; "MIAX"; end; end
class OptionExchangeCodes::N < OptionExchangeCodes; def name; "NYSE ArcaSM"; end; end
class OptionExchangeCodes::Q < OptionExchangeCodes; def name; "NASDAQ"; end; end
class OptionExchangeCodes::T < OptionExchangeCodes; def name; "NASDAQ OMX BX Options"; end; end
class OptionExchangeCodes::W < OptionExchangeCodes; def name; "C2"; end; end
class OptionExchangeCodes::X < OptionExchangeCodes; def name; "NASDAQ OMX PHLX"; end; end
class OptionExchangeCodes::Z < OptionExchangeCodes; def name; "BATS"; end; end
