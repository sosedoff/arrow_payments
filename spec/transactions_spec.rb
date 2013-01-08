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
      stub_request(:get, "http://demo.arrowpayments.com/api/foobar/transaction/40023").
        to_return(:status => 200, :body => fixture('transaction.json'), :headers => {})

      tran = client.transaction('40023')

      tran.should_not be_nil
      tran.id.should eq(40023)
    end

    it 'returns nil if transaction does not exist' do
      stub_request(:get, "http://demo.arrowpayments.com/api/foobar/transaction/400231").
        to_return(:status => 404, :body => "", :headers => {:error => "Transaction Not Found"})

      client.transaction('400231').should be_nil
    end
  end

  describe '#transactions' do
    it 'raises error on invalid status argument' do
      expect { client.transactions(10162, 'Foo') }.to raise_error "Invalid status: Foo"
    end

    it 'returns unsettled transactions' do
      stub_request(:get, "http://demo.arrowpayments.com/api/foobar/customer/10162/Transactions/NotSettled").
        to_return(:status => 200, :body => fixture('transactions.json'), :headers => {})

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
    pending
  end

  describe '#capture_transaction' do
    it 'raises error if transaction does not exist' do
      stub_request(:post, "http://demo.arrowpayments.com/api/transaction/capture").
        with(
          :body => "{\"TransactionId\":10162,\"Amount\":100,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 404, :body => "", :headers => {:error => "Transaction Not Found"})

      expect { client.capture_transaction(10162, 100) }.to raise_error "Transaction Not Found"
    end

    it 'captures transaction for amount' do
      stub_request(:post, "http://demo.arrowpayments.com/api/transaction/capture").
        with(
          :body => "{\"TransactionId\":10162,\"Amount\":100,\"ApiKey\":\"foobar\",\"MID\":\"foo\"}",
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 200, :body => fixture('transaction_capture.json'), :headers => {})

      client.capture_transaction(10162, 100).should be_true
    end

    it 'raises a error if amount is greater than original' do
      pending
    end

    it 'raises an error if transaction is already captured' do
      pending
    end
  end

  describe '#void_transaction' do
    it 'raises an error if transaction does not exist' do
      pending
    end

    it 'voids transaction' do
      pending
    end

    it 'raises an error if transaction is already voided' do
      pending
    end
  end
end