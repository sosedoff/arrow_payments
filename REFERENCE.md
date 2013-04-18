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
