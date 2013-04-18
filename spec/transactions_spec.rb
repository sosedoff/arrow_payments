require 'spec_helper'

describe ArrowPayments::Transactions do
  let(:client) { ArrowPayments.client }

  before :all do
    ArrowPayments::Configuration.api_key = 'foobar'
    ArrowPayments::Configuration.merchant_id = 'foo'
    ArrowPayments::Configuration.mode = 'sandbox'
  end

  describe '#transaction' do
    it 'returns a transaction by ID' do
      stub_api(:get, "/foobar/transaction/40023",
        :status  => 200,
        :body    => fixture('transaction.json'),
        :headers => {}
      )

      transaction = client.transaction('40023')

      transaction.should_not be_nil
      transaction.id.should eq(40023)
    end

    it 'returns nil if transaction does not exist' do
      stub_request(:get, "#{api_url}/foobar/transaction/400231").
        to_return(:status  => 404,
                  :body    => "",
                  :headers => {:error => "Transaction Not Found"})

      client.transaction('400231').should be_nil
    end
  end

  describe '#transactions' do
    it 'raises error on invalid status argument' do
      expect { client.transactions(10162, 'Foo') }.to raise_error "Invalid status: Foo"
    end

    it 'returns unsettled transactions' do
      stub_request(:get, "#{api_url}/foobar/customer/10162/Transactions/NotSettled").
        to_return(:status  => 200,
                  :body    => fixture('transactions.json'),
                  :headers => {})

      transactions = client.transactions(10162, 'NotSettled')

      transactions.should_not be_empty
      transactions.size.should eq(2)
      transactions.map(&:status).uniq.first.should eq('Not Settled')
    end

    it 'returns transactions for status' do
      pending 'API endpoint is not implemented'
    end
  end

  describe '#create_transaction' do
    let(:payment_information) do
      {
        :customer_id        => "10162",
        :payment_method_id  => '0',
        :transaction_type   => 'sale',
        :total_amount       => 250,
        :tax_amount         => 0,
        :shipping_amount    => 0
      }
    end

    let(:request) do
      {
        :body => "{\"TransactionType\":\"sale\",\"TotalAmount\":250,\"TransactionSource\":\"API\",\"PaymentMethodID\":\"0\",\"TaxAmount\":0,\"ShippingAmount\":0,\"CustomerID\":\"10162\",\"Amount\":250,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
      }
    end

    it "creates a new transaction record" do
      stub_request(:post, "#{api_url}/transaction/add").with(request).
        to_return(:status  => 200, 
                  :body    => fixture('transaction.json'), 
                  :headers => {})
      
      transaction = client.create_transaction(payment_information)
      transaction.should_not be_nil
      transaction.customer_name.should eq("First Supplies")
      transaction.authorization_code.should eq("123456")
      transaction.status.should eq("Not Settled")
    end

    it "raises an error if the payment method is not found" do
      stub_request(:post, "#{api_url}/transaction/add").with(request).
        to_return(:status => 404, 
                  :body => "", 
                  :headers => {:error => "Payment Method Not Found"})
      
      expect {client.create_transaction(payment_information) }.to raise_error "Payment Method Not Found"
    end
  end

  describe '#capture_transaction' do
    let(:request) do
      {
        :body    => "{\"TransactionId\":10162,\"Amount\":100,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
        :headers => {'Accept'=>'application/json','Content-Type'=>'application/json','User-Agent'=>'Ruby'}
      }
    end

    it 'raises error if transaction does not exist' do
      stub_request(:post, "#{api_url}/transaction/capture").with(request).
        to_return(:status  => 404,
                  :body    => "",
                  :headers => {:error => "Transaction Not Found"})

      expect { client.capture_transaction(10162, 100) }.to raise_error "Transaction Not Found"
    end

    it 'captures transaction for amount' do
      stub_request(:post, "#{api_url}/transaction/capture").with(request).
        to_return(:status  => 200,
                  :body    => fixture('transaction_capture.json'),
                  :headers => {})

      client.capture_transaction(10162, 100).should be_true
    end

    it 'raises a error if amount is greater than original' do

      stub_request(:post, "#{api_url}/transaction/capture").with(request).
        to_return(:status  => 400,
                  :body    => "",
                  :headers => {:error => "Unable to Capture for more than the original amount of $10.00"})

      expect { client.capture_transaction(10162, 100) }.to raise_error "Unable to Capture for more than the original amount of $10.00"
    end

    it 'raises an error if transaction is already captured' do
      stub_request(:post, "#{api_url}/transaction/capture").with(request).
        to_return(:status  => 400,
                  :body    => "",
                  :headers => {:error => "Transaction is Captured Already"})

      expect { client.capture_transaction(10162, 100) }.to raise_error "Transaction is Captured Already"
    end
  end

  describe '#void_transaction' do
    
    let(:request) do
      {
        :body    => "{\"TransactionId\":10162,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
      }
    end

    context "successful request" do
      it 'voids transaction' do
        stub_request(:post, "#{api_url}/transaction/void").with(request).
          to_return(:status  => 200, 
                    :body    => fixture("void_transaction.json"), 
                    :headers => {})
      
        client.void_transaction(10162).should be_true
      end
    end

    context "unsuccessful requests" do
      it 'raises an error if transaction does not exist' do
        stub_request(:post, "#{api_url}/transaction/void").with(request).
          to_return(:status  => 404, 
                    :body    => "", 
                    :headers => {:error => "Transaction Not Found"})
      
        expect { client.void_transaction(10162) }.to raise_error "Transaction Not Found"
      end

      it 'raises an error if transaction is already voided' do
        stub_request(:post, "#{api_url}/transaction/void").with(request)
          .to_return(:status  => 400,
                     :body    => "",
                     :headers => {:error => "Transaction Already Void"})
          
        expect { client.void_transaction(10162) }.to raise_error "Transaction Already Void"
      end
    end
  end
end
