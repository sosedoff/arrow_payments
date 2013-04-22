require 'spec_helper'

describe ArrowPayments::Connection do
  let(:subject) { ArrowPayments::Client.new(:api_key => 'foo', :merchant_id => 'bar') }

  it 'should timeout after 10 seconds' do
    stub_request(:get, "https://gateway.arrowpayments.com/api/foo/hello").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_timeout

    expect { subject.get('/hello') }.to raise_error Faraday::Error::TimeoutError
  end
end