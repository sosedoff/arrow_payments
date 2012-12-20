module ArrowPayments
  class PaymentMethod < Entity
    attr_accessor :number, :security_code

    property :id,               :from => 'ID'
    property :card_type,        :from => 'CardType'
    property :last_digits,      :from => 'Last4'
    property :first_name,       :from => 'CardholderFirstName'
    property :last_name,        :from => 'CardholderLastName'
    property :expiration_month, :from => 'ExpirationMonth'
    property :expiration_year,  :from => 'ExpirationYear'
    property :address,          :from => 'BillingStreet1'
    property :address2,         :from => 'BillingStreet2'
    property :city,             :from => 'BillingCity'
    property :state,            :from => 'BillingState'
    property :zip,              :from => 'BillingZip'
  end
end