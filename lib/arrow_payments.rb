require "arrow_payments/version"
require "arrow_payments/errors"

module ArrowPayments
  autoload :Configuration,    "arrow_payments/configuration"
  autoload :Entity,           "arrow_payments/entity"
  autoload :Customer,         "arrow_payments/customer"
  autoload :PaymentMethod,    "arrow_payments/payment_method"
  autoload :RecurringBilling, "arrow_payments/recurring_billing"
  autoload :Transaction,      "arrow_payments/transaction"
  autoload :Address,          "arrow_payments/address"
  autoload :LineItem,         "arrow_payments/line_item"
  autoload :Connection,       "arrow_payments/connection"
  autoload :Client,           "arrow_payments/client"

  autoload :Customers,        "arrow_payments/client/customers"
  autoload :PaymentMethods,   "arrow_payments/client/payment_methods"
  autoload :Transactions,     "arrow_payments/client/transactions"

  class << self
    def client(options = {})
      ArrowPayments::Client.new(options)
    end
  end
end
