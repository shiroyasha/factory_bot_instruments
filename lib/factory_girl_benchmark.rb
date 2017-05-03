require "factory_girl_benchmark/version"

require "factory_girl"
require "active_record"

module FactoryGirlBenchmark

  Benchmark = Struct.new(:factory, :method, :duration) do
    def to_s
      formated_duration = format("%5.3fs", duration)

      "#{formated_duration}: FactoryGirl.#{method}(:#{factory})"
    end
  end

  def self.run
    benchmark_all.each { |benchmark| puts benchmark }
  end

  def self.benchmark_all(methods: [:create, :build, :build_stubbed])
    report = FactoryGirl.factories.map(&:name).map do |factory|
      methods.map do |method|
        benchmark(factory, :method => method)
      end
    end

    report.flatten.sort_by(&:duration)
  end

  def self.benchmark(factory, method: :create)
    start = Time.now

    ActiveRecord::Base.transaction do
      FactoryGirl.public_send(method, factory)

      raise ActiveRecord::Rollback
    end

    Benchmark.new(factory, method, Time.now - start)
  end

end
