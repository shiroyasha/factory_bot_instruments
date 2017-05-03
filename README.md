# Factory Girl Instruments

This gem provides instruments for benchmarking, tracing, and debugging Factory
Girl models.

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
