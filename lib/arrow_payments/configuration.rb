module ArrowPayments
  class Configuration
    class << self
      attr_accessor :api_key, :mode, :merchant_id, :debug
    end
  end
end