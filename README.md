# Factory Bot Instruments

[![Gem Version](https://badge.fury.io/rb/factory_bot_instruments.svg)](https://badge.fury.io/rb/factory_bot_instruments)

Instruments for benchmarking, tracing, and debugging
[Factory Bot](https://github.com/thoughtbot/factory_bot) models.

Table of content:

- [Setup](#setup)
- [Benchmark one Factory](#benchmarking-one-factory-bot-model)
- [Benchmark all Factories](#benchmarking-all-factory-bot-models)
- [Trace Factory Bot calls](#tracing-factory-bot-calls)

## Purpose of this gem

Factory Bot is probably the base of your Rails test suite, but how deeply you
understand the models and the associations that are created in your tests?

Factory Bot Instruments help in these three aspects:

1. Slow test suites: Factory Bot is used for the bulk of tests in Rails. Even a
   small performance improvement in one of your factories can dramatically
   improve the speed of your overall test suite.

   Hint: Run `FactoryBot.benchmark_all`.

2. Deeper understanding of the database state: By tracing factory bot and SQL
   calls you can get a deeper understanding of what is actually created in your
   tests, helping you to debug the issues faster.

   Hint: Run `FactoryBot.trace { FactoryBot.create(:user) }`.

3. Find issues with missconfigured factories: When a factory is properly set up
   it is a bliss to work with it. However, if there is a hidden deep in the
   association chain debugging the created model can be a hellish experience.

   Hint: Run `FactoryBot.trace { FactoryBot.create(:user) }` and observe the
   chain of calls.

## Install

Add the following to your Gemfile:

```ruby
gem 'factory_bot_instruments'
```

and run `bundle install` from your shell.

To install the gem manually from your shell, run:

``` ruby
gem install factory_bot_instruments
```

## Documentation

### Benchmarking one Factory Bot model

If you have a `user` factory, you can benchmark it with:

``` ruby
FactoryBot.benchmark(:user)
```

By default, the `FactoryBot.create(<model>)` is called. You can pass `:method`
to override this:

``` ruby
FactoryBot.benchmark(:user, :method => :build_stubbed)
```

The above snippet will call `FactoryBot.build_stubbed(:user)`.

### Benchmarking all Factory Bot models

To collect benchmarking information from all Factory Bot models:

``` ruby
FactoryBot.benchmark_all
```

To skip a factory, pass the `:except` options:

``` ruby
FactoryBot.benchmark_all(:except => [:user])
```

By default, benchmarks for `FactoryBot.create(<model>)`,
`FactoryBot.build(<model>)`, `FactoryBot.build_stubbed(<model>)` are
collected. You can override this by passing an array of methods:

``` ruby
FactoryBot.benchmark_all(:methods => [:create]) # benchmark only :create
```

### Tracing Factory Bot calls

To trace factory Bot actions, wrap your call in the `FactoryBot.trace` method:

``` ruby
FactoryBot.trace do
  FactoryBot.create(:comment)
end
```

The above snippet will output the following tree:

``` txt
┌ (start) create :comment
|  ┌ (start) create :user
|  |  (0.1ms)  begin transaction
|  |  (0.4ms)  INSERT INTO "users" ("name", "username") VALUES (?, ?)  [["name", "Peter Parker"], ["username", "spiderman"]]
|  |  (2.3ms)  commit transaction
|  └ (finish) create :user [0.010s]
|  ┌ (start) create :article
|  |  ┌ (start) create :user
|  |  |  (0.1ms)  begin transaction
|  |  |  (0.3ms)  INSERT INTO "users" ("name", "username") VALUES (?, ?)  [["name", "Peter Parker"], ["username", "spiderman"]]
|  |  |  (1.8ms)  commit transaction
|  |  └ (finish) create :user [0.007s]
|  |  (0.1ms)  begin transaction
|  |  (0.2ms)  INSERT INTO "articles" ("title", "content", "user_id") VALUES (?, ?, ?)  [["title", "New Article"], ["content", "article content"], ["user_id", "121"]]
|  |  (1.5ms)  commit transaction
|  └ (finish) create :article [0.021s]
|  (0.1ms)  begin transaction
|  (0.2ms)  INSERT INTO "comments" ("content", "user_id", "article_id") VALUES (?, ?, ?)  [["content", "First!"], ["user_id", "120"], ["article_id", "61"]]
|  (1.5ms)  commit transaction
└ (finish) create :comment [0.046s]
```

To trace without SQL logs, use the following:

``` ruby
FactoryBot.trace(sql: false) do
  FactoryBot.create(:comment)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/shiroyasha/factory_girl_instruments. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code
of conduct.

## License

The gem is available as open source under the terms of
the [MIT License](http://opensource.org/licenses/MIT).
