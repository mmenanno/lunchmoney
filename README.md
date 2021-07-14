# lunchmoney-ruby

This gem and readme are very much a work in progress. More to come!

This gem is a library of the [LunchMoney API](https://lunchmoney.dev/) for the wonderful [LunchMoney](http://lunchmoney.app/) web app for personal finance & budgeting.

### Installation

Add this line to your application's `Gemfile`:
```Ruby
gem 'lunchmoney-ruby'
```

### Set your lunchmoney token

You can set your LunchMoney token either with a block like:
```Ruby
LunchMoney.configure do |config|
  config.token = "token"
end
```

or via an environment variable like `ENV['LUNCHMONEY_TOKEN'] = "token"`

### Using the API

Create an instance of the api, then call the endpoint you need:
```Ruby
api = LunchMoney::Api.new
api.get_all_categories
```
