REST API
========

## Security
The API endpoints exposed by the [PaymentServer](/paymentserver/readme.md) are secured by providing the following information for each API call:
- an [API key](/paymentserver/api-key.md)
- a computed API request body hash using `SHA256` or `SHA512`

## API endpoints

### Direct Payment

Endpoint: `/paymentrequest`

### Refund

Endpoint: `/refundrequest`