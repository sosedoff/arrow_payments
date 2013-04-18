# ArrowPayments

Ruby wrapper for Arrow Payments gateway

**Under Development**

## Installation

In your Gemfile add a line:

```
gem 'arrow_payments', :github => 'sosedoff/arrow_payments'
```

## Configuration

To configure gateway globally, add an initializer with the following:

```ruby
ArrowPayments::Configuration.api_key     = 'foo'
ArrowPayments::Configuration.mode        = 'production'
ArrowPayments::Configuration.merchant_id = '1231231'
```

Another way is to configure on the instance level:

```ruby
client = ArrowPayments::Client.new(
  :api_key     => 'foo', 
  :mode        => 'production',
  :merchant_id => '123451',
  :debug       => true
)
```

A set of helper methods:

```ruby
client.production? # => true
client.sandbox?    # => false
client.debug?      # => true
```

## Usage

Check the **API reference** section for objects details. 

Initialize a new client:

```ruby
client = ArrowPayments::Client.new(
  :api_key     => 'foo',
  :mode        => 'sandbox',
  :merchant_id => '12345'
)
```

### Customers

```ruby
# Get all customers. 
# Does not include recurring billings and payment methods.
client.customers # => [Customer, ...]

# Get customer details. 
# Returns nil if not found
client.customer('12345')

# Create a new customer. 
# Raises ArrowPayments::Error if unable to create.
customer = client.create_customer(
  :name    => 'John Doe',
  :contact => 'John Doe',
  :code    => 'JOHN',
  :email   => 'john@doe.com',
  :phone   => '(123) 123-12-12'
)

# Update an existing customer
customer      = client.customer('12345')
customer.name = 'Foo Bar'
client.update_customer(customer) # => true

# Delete an existing customer
client.delete_customer('12345') # => true
```

### Payment Methods

Example: Add a new payment method to an existing customer

```ruby
client_id = '12345'

# Initialize a new billing address instance
address = ArrowPayments::Address.new(
  :address  => 'Some Street',
  :address2 => 'Apt 1',
  :city     => 'Chicago',
  :state    => 'IL',
  :zip      => '60657',
  :phone    => '123123123'
)

# Initialize a new payment method instance
cc = ArrowPayments::PaymentMethod.new(
  :first_name       => 'John',
  :last_name        => 'Doe',
  :number           => '4111111111111111',
  :security_code    => '123',
  :expiration_month => 12,
  :expiration_year  => 14
)

# Step 1: Provide payment method customer and billing address
url = client.start_payment_method(customer_id, address)

# Step 2: Add credit card information
token = client.setup_payment_method(url, cc)

# Step 3: Finalize payment method creation
cc = client.complete_payment_methodtoken)

# Delete an existing payment method
client.delete_payment_method('123456') # => true
```

You can also create a payment method using a wrapper method:

```ruby
address = ArrowPayments::Address.new( ... data ... )
cc      = ArrowPayments::PaymentMethod.new( ... data ... )

# Returns a new PaymentMethod instance or raises errors
client.create_payment_method(customer_id, address, cc)
```

### Transactions

```ruby
# Get list of transactions by customer. 
# Only unsettled transactions will be returns as ArrowPayments does not support
# any other filters for now
client.transactions('12345')

# Get a single transaction details.
# Raises ArrowPayments::NotFound if not found
client.transaction('45678')

# Capture a transaction for a specified amount. 
# Returns success result or raises ArrowPayments::Error exception
client.capture_transaction('45678', 123.00)

# Void an existing unsettled transaction
# Returns a success result or raises ArrowPayments::NotFound if not found
client.void_transaction('45678')

# Create a new transaction for an existing custromer and payment method.
# Returns a new Transaction instance if request was successfull, otherwise
# raises ArrowPayments::Error exception with error message.
transaction = client.create_transaction(
  :customer_id        => 'Customer ID', 
  :payment_method_id  => 'Payment Method ID',
  :transaction_type   => 'sale',
  :total_amount       => 250,
  :tax_amount         => 0,
  :shipping_amount    => 0
)
```

## Reference

List of all gateway errors:

- `ArrowPayments::Error` - Raised on invalid data. Generic error.
- `ArrowPayments::NotFound` - Raised on invalid API token or non-existing object
- `ArrowPayments::NotImplemented` - Raised when API endpoint is not implemented

List of all gateway objects:

- `Customer`      - Gateway customer object
- `PaymentMethod` - Gateway payment method (credit card) object
- `Transaction`   - Contains all information about transaction 
- `Address`       - User for shipping and billing addresses
- `LineItem`      - Contains information about transaction item

### Address

- `address`
- `address2`
- `city`
- `state`
- `zip`
- `phone`
- `tag`

### Customer

- `id`
- `name`
- `code`
- `contact`
- `phone`
- `email`
- `recurring_billings` - Array of `RecurringBilling` instances if any
- `payment_methods` - Array of PaymentMethod instances if any

### PaymentMethod

- `id`
- `card_type`
- `last_digits`
- `first_name`
- `last_name`
- `expiration_month`
- `expiration_year`
- `address`
- `address2`
- `city`
- `state`
- `zip`

### LineItem

- `id`
- `commodity_code`
- `description`
- `price`
- `product_code`
- `unit_of_measure`

### Transaction

- `id`
- `account`
- `transaction_type`
- `created_at` - A `DateTime` object of creation
- `level`
- `total_amount`
- `description`
- `transaction_source`
- `status` - One of `NotSettled`, `Settled`, `Voided`, `Failed`
- `capture_amount`
- `authorization_code`
- `payment_method_id`
- `cardholder_first_name`
- `cardholder_last_name`
- `card_type`
- `card_last_digits`
- `customer_po_number`
- `tax_amount`
- `shipping_amount`
- `shipping_address_id`
- `shipping_address`
- `customer_id`
- `customer_name`
- `line_items`
- `billing_address`

## Testing

To run a test suite:

```
rake test
```

## TODO

There are multiple features that are pending implementation:

- Filter transactions by status
