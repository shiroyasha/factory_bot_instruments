require "factory_girl_benchmark/version"

require "factory_girl"

module FactoryGirlBenchmark

  def self.run
    FactoryGirl.factories.map(&:name).each do |factory|
      puts benchmark(factory)
    end
  end

  def self.benchmark(factory)
    start = Time.now

    ActiveRecord::Base.transaction do
      FactoryGirl.create(factory)

      raise ActiveRecord::Rollback
    end

    Time.now - start
  end

end
