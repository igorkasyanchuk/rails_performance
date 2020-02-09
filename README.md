# Rails Performance

Self-hosted tool to monitor the performance of your Ruby on Rails application.

This is **simple and free alternative** to New Relic, Datadog or other similar services.

It allows you to track:

- throughput report (see amount of requests per minute)
- an average response time
- the slowest controllers & actions
- duration of total time spent per request, views rendering, DB execution
- simple crash reports

All data is stored in local Redis and not sent to 3rd party servers.

## Production

Gem is production-ready. At least on my applications with ~800 unique users per day it works well.

## Usage

Create `config/initializers/rails_performance.rb`

```ruby
RailsPerformance.setup do |config|
  config.redis    = Redis::Namespace.new("#{Rails.env}-rails-performance", redis: Redis.new)
  config.duration = 24.hours

  config.debug    = false # currently not used>
  config.enabled  = true

  # protect your Performance Dashboard with HTTP BASIC password
  config.http_basic_authentication_enabled   = false
  config.http_basic_authentication_user_name = 'rails_performance'
  config.http_basic_authentication_password  = 'password12'

  # if you need an additional rules to check user permissions
  config.verify_access_proc = proc { |controller| true }
  # for example when you have `current_user`
  # config.verify_access_proc = proc { |controller| controller.current_user && controller.current_user.admin? }
end if defined?(RailsPerformance)
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

You must also have installed Redis server, because this gem is storing data into it.

After installation and configuration, start your Rails application, make a few requests, and open `https://localhost:3000/rails/performance` URL.

## Limitations

- it doesn't track params of POST/PUT requests
- it doesn't track SQL queries (at least for now)
- it doesn't track Redis/ElasticSearch or other apps
- it can't compare historical data
- depending on your load you may need to reduce time of for how long you store data, because all calculations are done in memory and it could take some time for high-load apps

## Redis

All information is stored into Redis. The default expiration time is set to `config.duration` from the configuration.

## Development & Testing

Just clone the repo, setup dummy app (`rails db:migrate`).

After this:

- rails s
- rake tests

Like a regular web development.

Please note that to simplify integration with other apps all CSS/JS are bundled inside, and delivered in body of the request. This is to avoid integration with assets pipeline or webpacker.

## Why

The idea of this gem grew from curriosity how many RPM my app receiving per day. Later it evolutionated to something more powerful.

## TODO

- documentation in Readme
- generator for initial config
- gif with demo
- time/zone config?
- CI for tests
- connected charts
- ability to zoom to see requests withing specific datime range
- better hint
- export to csv
- http basic auth config
- current_user auth config
- better stats tooltip, do not show if nothing to show
- dark mode toggle? save to the cookies
- integration with elastic search
- monitor active job (sidekiq)?
- logo?
- number of requests last 24 hours, hour, etc.

## Contributing

You are welcome to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
