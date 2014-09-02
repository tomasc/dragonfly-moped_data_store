# Dragonfly::MopedDataStore

[![Build Status](https://travis-ci.org/tomasc/dragonfly-moped_data_store.svg)](https://travis-ci.org/tomasc/dragonfly-moped_data_store) [![Gem Version](https://badge.fury.io/rb/dragonfly-moped_data_store.svg)](http://badge.fury.io/rb/dragonfly-moped_data_store) [![Coverage Status](https://img.shields.io/coveralls/tomasc/dragonfly-moped_data_store.svg)](https://coveralls.io/r/tomasc/dragonfly-moped_data_store)

[Dragonfly](https://github.com/markevans/dragonfly) data store that uses [Moped::GridFS](https://github.com/topac/moped-gridfs).

## Installation

Add this line to your application's Gemfile:

    gem 'dragonfly-moped_data_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dragonfly-moped_data_store

## Usage

You can configure Dragonfly to use the moped datastore in the dragonfly initializer like so:

```ruby
# config/initializers/dragonfly.rb

require 'dragonfly/moped_data_store'

Dragonfly.app.configure do
  datastore :moped, db: 'my-db', host: '127.0.0.1', port: '27017'
end
```

## Contributing

1. Fork it ( https://github.com/tomasc/dragonfly-moped_data_store/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
