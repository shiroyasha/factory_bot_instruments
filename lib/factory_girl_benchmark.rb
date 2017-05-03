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

  def self.run(options = {})
    default_options = { :progress => true }

    benchmark_all(default_options.merge(options)).each do |benchmark|
      puts benchmark
    end
  end

  def self.benchmark_all(
    except: [],
    methods: [:create, :build, :build_stubbed],
    progress: false)

    factories = FactoryGirl.factories.map(&:name) - except

    report = factories.map do |factory|
      puts "Processing #{factory}" if progress

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
