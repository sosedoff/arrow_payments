require 'spec_helper'

describe ArrowPayments::Customers do
  let(:client) { ArrowPayments.client }

  before :all do
    ArrowPayments::Configuration.api_key = 'foobar'
    ArrowPayments::Configuration.merchant_id = 'foo'
    ArrowPayments::Configuration.mode = 'sandbox'
    ArrowPayments::Configuration.debug = false
  end

  describe '#customers' do
    before { stub_api(:get, "/foobar/customers", :body => fixture('customers.json')) }

    it 'returns an array of existing customers' do
      customers = client.customers
      customers.should be_an Array
      customers.size.should eq(12)
    end
  end

  describe '#customer' do
    it 'returns an existing customer by ID' do
      stub_api(:get, "/foobar/customer/10162", :body => fixture('customer.json'))

      customer = client.customer(10162)
      customer.should_not be_nil
      customer.id.should eq(10162)
      customer.name.should eq('First Supplies')
    end

    it 'returns nil if customer does not exist' do
      stub_api(:get, "/foobar/customer/12345", :status => 404, :headers => {error: "Customer Not Found"})

      customer = client.customer(12345)
      customer.should be_nil
    end
  end

  describe '#create_customer' do
    let(:customer) do
      ArrowPayments::Customer.new(
        :name    => 'First Supplies',
        :code    => 'First Supplies',
        :contact => 'John Peoples',
        :email   => 'John.Peoples@arrow-test.com',
        :phone   => '8325539616'
      )
    end

    it 'creates and returns a new customer' do
      stub_api(:post, "/customer/add", :body => fixture("customer.json"))

      new_customer = client.create_customer(customer)
      new_customer.id.should eq(10162)
    end

    it 'raises error when unable to create' do
      stub_api(:post, "/customer/add", :status => 500, :headers => { :error => "Customer with Name First Supplies already exists for merchant"})

      expect { client.create_customer(customer) }.to raise_error ArrowPayments::Error, 'Customer with Name First Supplies already exists for merchant'
    end
  end

  describe '#update_customer' do
    before { stub_api(:get, "/foobar/customer/10162", :body => fixture('customer.json')) }

    it 'raises error if customer does not exist' do
      stub_request(:post, "#{api_url}/customer/update").
        with(
          :body    => "{\"ID\":\"10163\",\"Name\":\"Foobar\",\"Code\":\"First Supplies\",\"PrimaryContact\":\"John Peoples\",\"PrimaryContactPhone\":\"8325539616\",\"PrimaryContactEmailAddress\":\"John.Peoples@arrow-test.com\",\"RecurrentBilling\":[],\"PaymentMethods\":[{\"ID\":12436,\"CardType\":\"Visa\",\"Last4\":\"1111\",\"CardholderFirstName\":\"Paola\",\"CardholderLastName\":\"Chen\",\"ExpirationMonth\":6,\"ExpirationYear\":2015,\"BillingStreet1\":\"7495 Center St.\",\"BillingCity\":\"Chicago\",\"BillingState\":\"IL\",\"BillingZip\":\"60601\"}],\"CustomerID\":\"10163\",\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 404, :body => "", :headers => {:error => "Customer Not Found"})

      customer      = client.customer('10162')
      customer.id   = '10163'
      customer.name = 'Foobar'

      expect { client.update_customer(customer) }.
        to raise_error ArrowPayments::NotFound, 'Customer Not Found'
    end

    it 'raises error if customer is not valid' do
      stub_request(:post, "#{api_url}/customer/update").with(
          :body => "{\"ID\":10162,\"Name\":\"Foobar\",\"Code\":\"First Supplies\",\"PrimaryContact\":\"John Peoples\",\"PrimaryContactPhone\":\"8325539616\",\"PrimaryContactEmailAddress\":\"John.Peoples@arrow-test.com\",\"RecurrentBilling\":[],\"PaymentMethods\":[{\"ID\":12436,\"CardType\":\"Visa\",\"Last4\":\"1111\",\"CardholderFirstName\":\"Paola\",\"CardholderLastName\":\"Chen\",\"ExpirationMonth\":6,\"ExpirationYear\":2015,\"BillingStreet1\":\"7495 Center St.\",\"BillingCity\":\"Chicago\",\"BillingState\":\"IL\",\"BillingZip\":\"60601\"}],\"CustomerID\":10162,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).to_return(:status  => 500,
                    :body    => "",
                    :headers => {:error => "Customer with Name Foobar already exists for merchant"})

      customer      = client.customer('10162')
      customer.name = 'Foobar'

      expect { client.update_customer(customer) }.
        to raise_error ArrowPayments::Error, 'Customer with Name Foobar already exists for merchant'
    end

    it 'returns true if customer was updated' do
      stub_request(:post, "#{api_url}/customer/update").with(
          :body    => "{\"ID\":10162,\"Name\":\"Foobar\",\"Code\":\"First Supplies\",\"PrimaryContact\":\"John Peoples\",\"PrimaryContactPhone\":\"8325539616\",\"PrimaryContactEmailAddress\":\"John.Peoples@arrow-test.com\",\"RecurrentBilling\":[],\"PaymentMethods\":[{\"ID\":12436,\"CardType\":\"Visa\",\"Last4\":\"1111\",\"CardholderFirstName\":\"Paola\",\"CardholderLastName\":\"Chen\",\"ExpirationMonth\":6,\"ExpirationYear\":2015,\"BillingStreet1\":\"7495 Center St.\",\"BillingCity\":\"Chicago\",\"BillingState\":\"IL\",\"BillingZip\":\"60601\"}],\"CustomerID\":10162,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).to_return(:status => 200,
                    :body   => {'Success' => true}.to_json)

      customer      = client.customer('10162')
      customer.name = 'Foobar'

      client.update_customer(customer).should be_true
    end
  end

  describe '#delete_customer' do
    it 'raises error if customer does not exist' do
      stub_api(:post, "/customer/delete", :status => 404, :headers => { :error => "Customer Not Found" })

      expect { client.delete_customer(10162) }.
        to raise_error ArrowPayments::NotFound, 'Customer Not Found'
    end

    it 'returns true if customer was deleted' do
      stub_api(:post, "/customer/delete", :status => 200, :body => {"Success" => true}.to_json)

      client.delete_customer(10162).should be_true
    end
  end
end
