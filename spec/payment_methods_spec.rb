require 'spec_helper'

describe ArrowPayments::PaymentMethods do
  let(:client) { ArrowPayments.client }

  before :all do
    ArrowPayments::Configuration.api_key = 'foobar'
    ArrowPayments::Configuration.merchant_id = 'foo'
    ArrowPayments::Configuration.mode = 'sandbox'
  end

  describe '#start_payment_method' do
    it 'raises error if customer does not exist' do
      stub_request(:post, "http://demo.arrowpayments.com/api/paymentmethod/start").
        with(
          :body => "{\"CustomerId\":11843,\"BillingAddress\":{},\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 404, :body => "", :headers => {:error => "Invalid customer"})

      expect { client.start_payment_method(11843, {}) }.
        to raise_error ArrowPayments::NotFound, "Invalid customer"
    end

    it 'raises error if address is not valid' do
      stub_request(:post, "http://demo.arrowpayments.com/api/paymentmethod/start").
        with(
          :body => "{\"CustomerId\":11843,\"BillingAddress\":{},\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 500, :body => "", :headers => {:error => "Something went wrong"})

      expect { client.start_payment_method(11843, {}) }.
        to raise_error ArrowPayments::Error
    end

    it 'returns submit form url' do
      address = {
        :address  => '3128 N Broadway',
        :address2 => "Upstairs",
        :city     => 'Chicago',
        :state    => 'IL',
        :zip      => '60657',
        :phone    => '123123123'
      }

      stub_request(:post, "http://demo.arrowpayments.com/api/paymentmethod/start").
        with(
          :body => "{\"CustomerId\":11843,\"BillingAddress\":{\"Address1\":\"3128 N Broadway\",\"Address2\":\"Upstairs\",\"City\":\"Chicago\",\"State\":\"IL\",\"Postal\":\"60657\",\"Phone\":\"123123123\"},\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 200, :body => fixture('start_payment_method.json'), :headers => {})

      url = client.start_payment_method(11843, address)
      url.should eq('https://secure.nmi.com/api/v2/three-step/4i873m0s')
    end
  end

  describe '#setup_payment_method' do
    it 'return token to complete payment' do
      url = 'https://secure.nmi.com/api/v2/three-step/4i873m0s'

      card = {
        :first_name       => 'John',
        :last_name        => 'Doe',
        :number           => '4111111111111111',
        :security_code    => '123',
        :expiration_month => 12,
        :expiration_year  => 14
      }
      
      stub_request(:post, "https://secure.nmi.com/api/v2/three-step/4i873m0s").
        with(
          :body => {"billing-cc-exp"=>"1214", "billing-cc-number"=>"4111111111111111", "billing-cvv"=>"123", "billing-first-name"=>"John", "billing-last-name"=>"Doe"},
          :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}
        ).
        to_return(
          :status => 200, 
          :body => "", 
          :headers => {:location => 'http://arrowdemo.cloudapp.net/api/echo?token-id=4i873m0s'}
        )

      token = client.setup_payment_method(url, card)
      token.should eq('4i873m0s')
    end
  end

  describe '#complete_payment_method' do
    it 'returns a newly created payment method' do
      token = '4i873m0s'

      stub_request(:post, "http://demo.arrowpayments.com/api/paymentmethod/complete").
        with(
          :body => "{\"TokenID\":\"4i873m0s\",\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 200, :body => fixture('complete_payment_method.json'), :headers => {})

      card = client.complete_payment_method(token)
      card.should be_a ArrowPayments::PaymentMethod
      card.id.should eq(14240)
    end
  end
end