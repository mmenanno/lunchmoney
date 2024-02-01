[![Gem Version](https://badge.fury.io/rb/lunchmoney.svg)](https://badge.fury.io/rb/lunchmoney)
[![CI](https://github.com/halorrr/lunchmoney/actions/workflows/ci.yml/badge.svg)](https://github.com/halorrr/lunchmoney/actions/workflows/ci.yml)
[![Yard Docs](https://github.com/halorrr/lunchmoney/actions/workflows/build_and_publish_yard_docs.yml/badge.svg)](https://github.com/halorrr/lunchmoney/actions/workflows/build_and_publish_yard_docs.yml)

# lunchmoney

This gem and readme are very much a work in progress. More to come!

This gem is a library of the [LunchMoney API](https://lunchmoney.dev/) for the wonderful [LunchMoney](http://lunchmoney.app/) web app for personal finance & budgeting.

You can find the yard docs for this gem [here](https://halorrr.github.io/lunchmoney/)

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

Create an instance of the api, then call the endpoint you need:

```Ruby
api = LunchMoney::Api.new
api.categories
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
