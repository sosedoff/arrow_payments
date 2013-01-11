require 'spec_helper'

describe ArrowPayments::RecurringBilling do
  it { should respond_to :id }
  it { should respond_to :payment_method_id }
  it { should respond_to :frequency }
  it { should respond_to :total_amount }
  it { should respond_to :shipping_amount }
  it { should respond_to :description }
  it { should respond_to :transaction_day }
  it { should respond_to :date_created }
  it { should respond_to :frequency_name }

  describe '#frequency_name' do
    let(:billing) { ArrowPayments::RecurringBilling.new }

    it 'returns nil is frequency is not set' do
      billing.frequency_name.should be_nil
    end

    it 'returns a human name for frequency' do
      %w(W M Q Y).each do |s|
        billing.frequency = s
        billing.frequency_name.should_not be_nil
      end
    end
  end
end