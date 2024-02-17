# lunchmoney

[![Gem Version](https://badge.fury.io/rb/lunchmoney.svg)](https://badge.fury.io/rb/lunchmoney)
[![CI](https://github.com/mmenanno/lunchmoney/actions/workflows/ci.yml/badge.svg)](https://github.com/mmenanno/lunchmoney/actions/workflows/ci.yml)
[![Yard Docs](https://github.com/mmenanno/lunchmoney/actions/workflows/build_and_publish_yard_docs.yml/badge.svg)](https://github.com/mmenanno/lunchmoney/actions/workflows/build_and_publish_yard_docs.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/6e84458e8cf831e6a6fa/maintainability)](https://codeclimate.com/github/mmenanno/lunchmoney/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6e84458e8cf831e6a6fa/test_coverage)](https://codeclimate.com/github/mmenanno/lunchmoney/test_coverage)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/gbraad)

This gem is a API client library of the [LunchMoney API](https://lunchmoney.dev/) for the wonderful [LunchMoney](http://lunchmoney.app/) web app for personal finance & budgeting.

Documentation is still a work in process, but you can find the yard docs for this gem [here](https://mmenanno.github.io/lunchmoney/) as well as some write ups of the basics below. An example of every call is listed on the [Api class in the yard docs](https://mmenanno.github.io/lunchmoney/LunchMoney/Api.html).

## Usage

### Installation

Add this line to your application's `Gemfile`:

```Ruby
gem "lunchmoney"
```

### Set your lunchmoney token

There are a few ways you can set your API token. You can set it manually using a configure block:

```Ruby
LunchMoney.configure do |config|
  config.api_key = "your_api_key"
end
```

The config will also _automatically_ pull in the token if set via environment variable named `LUNCHMONEY_TOKEN`

You can also override the config and set your LunchMoney token for a specific API instance via kwarg:

```Ruby
LunchMoney::Api.new(api_key: "your_api_key")
```

### Using the API

It is intended that all calls typically go through a `LunchMoney::Api` instannce. This class delegates methods to their
relvant classes behind the scenes. Create an instance of the api, then call the endpoint you need:

```Ruby
api = LunchMoney::Api.new
api.categories
```

When the api returns an error a `LunchMoney::Errors` object will be returned. You can check the errors that occured via
`.messages` on the instance. This will return an array of errors.

```Ruby
api = LunchMoney::Api.new
response = api.categories

response.class
=> LunchMoney::Errors

response.messages
=> ["Some error returned by the API"]
```

The instance itself has been set up to act like an array, delegating a lot of common array getter methods directly to
messages for you. This enables things like:

```Ruby
api = LunchMoney::Api.new
response = api.categories

response.class
=> LunchMoney::Errors

response.first
=> "Some error returned by the API"

response.empty?
=> false

response[0]
=> "Some error returned by the API"
```

## Contributing to this repo

Feel free to contribute and submit PRs to improve this gem

## Releasing a new gem version

1. Bump the `VERSION` constant in `lib/lunchmoney/version.rb`
2. Run `bundle install`
3. Commit and push up the change in a PR
4. Merge the PR
5. Create a new tag and release with the name version as v0.0.0
6. A Github action will kick off and publish the new gem version
