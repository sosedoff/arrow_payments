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
ArrowPayments::Configuration.api_key = 'foo'
ArrowPayments::Configuration.mode = 'production'
ArrowPayments::Configuration.merchant_id = '1231231'
```

Another way is to configure on the instance level:

```ruby
client = ArrowPayments::Client.new(
  :api_key => 'foo', 
  :mode => 'production',
  :merchant_id => '123451'
)

client.production? # => true
```

## Usage

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
  :name => 'John Doe',
  :contact => 'John Doe',
  :code => 'JOHN',
  :email => 'john@doe.com',
  :phone => '(123) 123-12-12'
)

# Update a customer
# NOTE: Not implemented by ArrowPayments

# Delete a customer
# NOTE: Not implementer by ArrowPayments
```

### Payments Methods

```ruby
# TODO
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
```

## Reference

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