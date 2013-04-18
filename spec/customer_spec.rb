require 'spec_helper'

describe ArrowPayments::Customer do
  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :code }
  it { should respond_to :contact }
  it { should respond_to :phone }
  it { should respond_to :email }
  it { should respond_to :recurring_billings }
  it { should respond_to :payment_methods }

  describe '#new' do
    let(:customer_data) { json_fixture('customer.json') }

    it 'properly assigns attributes' do
      customer = ArrowPayments::Customer.new(customer_data)

      customer.id.should eq(10162)
      customer.name.should eq('First Supplies')
      customer.code.should eq('First Supplies')
      customer.contact.should eq('John Peoples')
      customer.phone.should eq('8325539616')
      customer.email.should eq('John.Peoples@arrow-test.com')
      customer.recurring_billings.should be_empty
      customer.payment_methods.should_not be_empty
    end
  end
end
