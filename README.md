# RailsPerformance

Short description and motivation.

## Usage

Create `config/initializers/rails_performance.rb`

```ruby
RailsPerformance.setup do |config|
  config.redis = Redis.new
  config.days  = 3
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_performance'
```

And then execute:
```bash
$ bundle
```

## TODO

- documentation
- time/zone config?
- CI for tests
- better hint
- export to csv
- http basic auth
- better stats tooltip, do not show if nothing to show

## Contributing

You are welcome to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
