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

- time/zone
- redis namespaces
- skip for tests ?
- documentation
- add 1 if 0 (it means one request was)
- better hint

## Contributing

You are welcome to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
