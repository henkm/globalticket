# Globalticket
[![Build Status](https://secure.travis-ci.org/henkm/globalticket.png)](http://travis-ci.org/henkm/globalticket)
[![Gem Version](https://badge.fury.io/rb/globalticket.svg)](https://badge.fury.io/rb/globalticket)
[![Dependency Status](https://gemnasium.com/henkm/globalticket.svg)](https://gemnasium.com/henkm/globalticket)
[![Code Climate](https://codeclimate.com/github/henkm/globalticket/badges/gpa.svg)](https://codeclimate.com/github/henkm/globalticket)

This gem works as a simple Ruby wrapper for the Global Ticket Resller API. It implements all the API functions are implemented. Please refer to the awesome [Global Ticket Resller documentation](https://globalreseller.nl/documentation/) to see how the API works.


All this gem does, is make it a little bit simpler to use the API:
- You don't need to sort the attributes
- You don't need to calculate the HMAC Key
- You don't need to send your API key or environment with every request
- You don't need to figure out how to make the POST requests

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'globalticket'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install globalticket

## Configuration

First, obtain an API key and shared secret from Global Ticket. Set it up like this:
```ruby
Globalticket::Config.api_key      = "MY-API-KEY"
Globalticket::Config.api_secret   = "MY-API-SHARED-SECRET"
Globalticket::Config.environment  = "test" # or 'production'
```

To use this gem in a Rails project:
```ruby
# config/development.rb
config.globalticket.api_key      = "MY-API-KEY"
config.globalticket.api_secret   = "MY-API-SHARED-SECRET"
config.globalticket.environment  = "test" # or 'production'
```

## Usage

### Get available users
```ruby
@global_ticket_users = Globalticket::API.get_available_users
# => {"success"=>true, "users"=>[{"userId"=>"xx", "userName"=>"Name of the museum", etc..}, {"userId"=>"yy", "userName"=>"Name of the museum", etc..}]}
```

### Get ticket types
```ruby
@ticket_types = Globalticket::API.get_ticket_types(userId: xx)
# => {"success"=>true, "ticketTypes"=>[{"ticketTypeId"=>xx, "ticketTypeName"=>"Dagticket", "ticketTypePrice"=>"10.00"}, ...]}
```

### Etcetera

All the other functions work exactly in the same fashion. Checkout the globalticket_spec.rb file to see some more examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/henkm/globalticket.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

This gem is made with love by the smart people at [Eskes Media B.V.](http://www.eskesmedia.nl) and [dagjewegtickets.nl](https://www.dagjewegtickets.nl)
Global Ticket is not involved with this project and has no affiliation with Eskes Media B.V.
