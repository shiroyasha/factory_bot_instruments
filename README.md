# Factory Girl Instruments

This gem provides instruments for benchmarking, tracing, and debugging Factory
Girl models.

- [Benchmark one Factory](#benchmarking-one-factory-girl-model)
- [Benchmark all Factories](#benchmarking-all-factory-girl-models)
- [Trace Factory Girl calls](#tracing-factory-girl-calls)

## Setup

Add the following to your Gemfile:

```ruby
gem 'factory_girl_instruments'
```

## Benchmarking one Factory Girl model

If you have a `user` factory, you can benchmark it with:

``` ruby
FactoryGirl.benchmark(:user)
```

By default, the `FactoryGirl.crete(<model>)` is called. You can pass `:method`
to override this:

``` ruby
FactoryGirl.benchmark(:user, :method => :build_stubbed)
```

The above snippet will call `FactoryGirl.build_stubbed(:user)`.

## Benchmarking all Factory Girl models

To collect benchmarking information from all Factory Girl models:

``` ruby
FactoryGirl.benchmark_all
```

To skip a factory, pass the `:except` options:

``` ruby
FactoryGirl.benchmark_all(:except => [:user])
```

By default, benchmarks for `FactoryGirl.create(<model>)`,
`FactoryGirl.build(<model>)`, `FactoryGirl.build_stubbed(<model>)` are
collected. You can override this by passing an array of methods:

``` ruby
FactoryGirl.benchmark_all(:methods => [:create]) # benchmark only :create
```

## Tracing Factory Girl calls

To trace factory girl actions, wrap your call in the `FactoryGirl.trace` method:

``` ruby
FactoryGirl.trace do
  FactoryGirl.create(:comment)
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
FactoryGirl.trace(sql: false) do
  FactoryGirl.create(:comment)
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
