- Unreleased

- 1.4.1
  - switch to ApexCharts https://github.com/igorkasyanchuk/rails_performance/pull/117
  - upgraded dummy app to rails 8 https://github.com/igorkasyanchuk/rails_performance/pull/119

- 1.4.0
  - track CPU, memory, storage: https://github.com/igorkasyanchuk/rails_performance/pull/111
  - use UTC time: https://github.com/igorkasyanchuk/rails_performance/pull/114
  - custom expiration time for system monitoring report: https://github.com/igorkasyanchuk/rails_performance/pull/115/files

- 1.3.3
  - little improvements and bug fixes
  - changes in the readme

- 1.3.2
  - small UI improvements
  - added option to ignore "ignore_trace_headers" (details we show in trace report in header)

- 1.3.1
  - added percentile report https://github.com/igorkasyanchuk/rails_performance/pull/108
  - removed "redis-namespace" gem as depenedency

- 1.3.0
  - added csv export https://github.com/igorkasyanchuk/rails_performance/pull/100
  - hide empty tooltips https://github.com/igorkasyanchuk/rails_performance/pull/101
  - added standardrb https://github.com/igorkasyanchuk/rails_performance/pull/103

- 1.2.3
  - typo fix https://github.com/igorkasyanchuk/rails_performance/pull/91
  - added ignored_paths https://github.com/igorkasyanchuk/rails_performance/pull/96
  - CI for new versions of Ruby

- 1.2.2
  - fixed issue with undefined helpers https://github.com/igorkasyanchuk/rails_performance/pull/78
  - configuration for include_rake_tasks, include_custom_events monitoring

- 1.2.1
  - Depend only on railties instead of rails https://github.com/igorkasyanchuk/rails_performance/pull/63
  - Delete unused .travis.yml https://github.com/igorkasyanchuk/rails_performance/pull/62
  - CI: Tell dependabot to update GH Actions https://github.com/igorkasyanchuk/rails_performance/pull/61

- 1.2.0
  - IMPORTANT: for some time might show incorrect values in the chart (until old records will be expired). Just give it some time
  - PR https://github.com/igorkasyanchuk/rails_performance/pull/53/files
    - support for Rails app without Active Record
    - added icon to indicate that request was received by bot or human
    - little internal refactoring
    - support for app timezone (show datetime in the App timezone)

- 1.1.0
  - remember "auto-update" state for Recent tab https://github.com/igorkasyanchuk/rails_performance/pull/51
  - added Slow Requests tab https://github.com/igorkasyanchuk/rails_performance/pull/51

- 1.0.5.3
  - two new options to configure Recent tab
    config.recent_requests_time_window = 60.minutes
    config.recent_requests_limit = nil
  - little UI improvements

- 1.0.5.1, 1.0.5.2
  - hotfixes

- 1.0.5
  - updated dev dependencies
  - added support for storing custom_data (see readme)

- 1.0.4
  - Add skipable rake config https://github.com/igorkasyanchuk/rails_performance/pull/44

- 1.0.3
  - autoupdate Recent tab with recent requests https://github.com/igorkasyanchuk/rails_performance/pull/40

- 1.0.2
  - Add home button link customization https://github.com/igorkasyanchuk/rails_performance/pull/36
  - Fix navbar toggle https://github.com/igorkasyanchuk/rails_performance/pull/38

1.0.1
  - Rake task integration: respect enabled setting https://github.com/igorkasyanchuk/rails_performance/pull/30

1.0.0
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
  - fix for issue with disabled `serve_static_files` https://github.com/igorkasyanchuk/rails_performance/issues/29

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
