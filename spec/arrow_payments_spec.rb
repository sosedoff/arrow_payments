require 'spec_helper'

describe ArrowPayments do
  describe '#client' do
    it 'returns client instance for options' do
      client = ArrowPayments.client(
        :api_key => 'foo', 
        :mode => 'production',
        :merchant_id => 12345
      )

      client.should be_a ArrowPayments::Client
      client.api_key.should eq('foo')
      client.mode.should eq('production')
      client.merchant_id.should eq(12345)
      client.debug.should eq(false)
    end

    context 'when preconfigured' do
      before do
        ArrowPayments::Configuration.api_key = 'bar'
        ArrowPayments::Configuration.mode = 'sandbox'
        ArrowPayments::Configuration.merchant_id = 12345
      end

      after do
        ArrowPayments::Configuration.api_key = nil
        ArrowPayments::Configuration.mode = nil
        ArrowPayments::Configuration.merchant_id = nil
      end
      
      it 'returns preconfigured client instance' do
        client = ArrowPayments.client
        client.api_key.should eq('bar')
        client.mode.should eq('sandbox')
        client.merchant_id.should eq(12345)
      end
    end
  end
end
