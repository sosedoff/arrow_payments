require 'spec_helper'

describe ArrowPayments::Client do
  describe '#initialize' do
    it 'requires an api key' do
      expect { ArrowPayments::Client.new }.to raise_error "API key required"
    end

    it 'requires a merchant id' do
      expect { ArrowPayments::Client.new(:api_key => 'foobar') }.
        to raise_error "Merchant ID required"
    end

    it 'validates api mode' do
      expect { ArrowPayments::Client.new(:api_key => 'foobar', :merchant_id => 'foobar', :mode => 'foobar') }.
        to raise_error "Invalid mode: foobar"
    end

    it 'sets production mode by default' do
      client = ArrowPayments::Client.new(:api_key => 'foobar', :merchant_id => 'foobar')
      client.mode.should eq('production')
    end
  end

  describe '#sanbox?' do
    it 'returns true if sandbox mode' do
      client = ArrowPayments::Client.new(:api_key => 'foobar', :merchant_id => 'foobar', :mode => 'sandbox')

      client.sandbox?.should be_true
      client.production?.should_not be_true
    end
  end

  describe '#production?' do
    it 'returns true if production mode' do
      client = ArrowPayments::Client.new(:api_key => 'foobar', :merchant_id => 'foobar', :mode => 'production')

      client.sandbox?.should be_false
      client.production?.should be_true
    end
  end
end
