require 'spec_helper'

describe ArrowPayments::Configuration do
  describe '#api_key=' do
    it 'sets gateway api key' do
      ArrowPayments::Configuration.api_key = 'foobar'
      ArrowPayments::Configuration.api_key.should eq('foobar')
    end
  end

  describe '#mode=' do
    it 'sets gateway mode' do
      ArrowPayments::Configuration.mode = 'production'
      ArrowPayments::Configuration.mode.should eq('production')
    end
  end

  describe '#merchant_id=' do
    it 'sets merchant ID' do
      ArrowPayments::Configuration.merchant_id = 12345
      ArrowPayments::Configuration.merchant_id.should eq(12345)
    end
  end
end