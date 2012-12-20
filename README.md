# ArrowPayments

Ruby wrapper for Arrow Payments gateway

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

```
client = ArrowPayments::Client.new(
  :api_key => 'foo', 
  :mode => 'production',
  :merchant_id => '123451'
)

client.production? # => true
```

## Usage

TODO

## Testing

To run a test suite:

```
rake test
```