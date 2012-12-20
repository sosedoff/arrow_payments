module ArrowPayments
  class Configuration
    class << self
      attr_accessor :api_key, :mode, :merchant_id
    end
  end
end