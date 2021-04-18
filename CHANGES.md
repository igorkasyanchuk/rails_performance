1.0.0 (unreleased)
  - support Redis cluster by default https://github.com/igorkasyanchuk/rails_performance/pull/26/files
  - added instructions how to mount engine manutally in secured scope https://github.com/igorkasyanchuk/rails_performance/pull/27
```ruby
    authenticate :user, -> (user) { user.admin? } do
      mount RailsPerformance::Engine, at: 'rails/performance'
    end
```
  - refactored code, more tests added
  - added support for Dalayed Job gem
  - added support for Rake tasks
  - added support for Grape API
  - added support for Custom event tracking

0.9.9
  - fix "enabled" behavior https://github.com/igorkasyanchuk/rails_performance/pull/23

0.9.8
  - added "ignored_endpoints" options https://github.com/igorkasyanchuk/rails_performance/pull/22
  - small changes in readme https://github.com/igorkasyanchuk/rails_performance/pull/21
  - added generator https://github.com/igorkasyanchuk/rails_performance/pull/20
  - added github actions

0.9.7
  - re-raise error in sidekiq https://github.com/igorkasyanchuk/rails_performance/pull/18
  - match mount url in collector https://github.com/igorkasyanchuk/rails_performance/pull/19

0.9.6
  - support for Ruby 2.2
  - mount at needed path, using configuration option
  - confirmed support for Rails 5.X

0.9.5
  - Isolate namespace and helpers to skip overiding helpers

0.9.4
  - Better thread safe
  - added an additional icon to see the details of the request

0.9.3
  - Rails 4.2 support added (and probably >= 4.0)

0.9.2
  - fixed days calculation

0.9.1
  - sidekiq stats

0.9.0.X
  - fully working version
  - capture all requests
  - detailed information for request
  - 500 crash reports
  - tested on  production

0.1.X
  - working prototype