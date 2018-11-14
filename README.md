# DNServer

A WIP DNS Server.  

# Built with

- Ruby 2.5.1
- Ruby on Rails v5.2.1
- SQLite v3.24.0

# Features implemented

- Basic CRUD API for zones & records.  I used `rails g scaffold ...` for the views & controllers, as CRUD was the least interesting piece of this exercise
- Zones have validations for domain names as they are described in [RFC 1034 Section 3.1](https://tools.ietf.org/html/rfc1034#section-3.1)
  - An empty string is considered a valid domain name.
- Records have validations for names, record types, record classes, and rdata,
  - `:name` is joined with the parent zone name before being validated
  - `:record type` validation currently covers A, CNAME, and unknown types.  I did not

# Usage

    $ bundle
    $ bin/rails db:migrate
    $ bin/rails test

# Notes

- The interesting parts of this code are really the model validations, the validators in `test/validators`, and the validator tests in `test/validators`.
