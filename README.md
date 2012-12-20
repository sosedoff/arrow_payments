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

## Reference

List of all gateway objects

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

## LineItem

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