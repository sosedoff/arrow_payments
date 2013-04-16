require 'spec_helper'

describe ArrowPayments::PaymentMethod do
  it { should respond_to :id }
  it { should respond_to :card_type }
  it { should respond_to :last_digits }
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :expiration_month }
  it { should respond_to :expiration_year }
  it { should respond_to :address }
  it { should respond_to :address2 }
  it { should respond_to :city }
  it { should respond_to :state }
  it { should respond_to :zip }
end
