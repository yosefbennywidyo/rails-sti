# README

This project using [Single Table Inheritance](https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html)

## Clients

There are 3 clients type:

- User
- Team
- Stock

Client can do debit (withdraw or transfer to other client) and credit (deposit or get transfer from other client).

## Debit or Credit

From the root path:
- select one client type
- check transaction
- select Credit or Debit

## Test

```ruby
rails test
```

## Requirements:

- Ruby version: 3.1.0
- Rails version: 7.0.1
- Node version: 16.4.0
- NPM version: 7.18.1
- Yarn version: 1.22.17
