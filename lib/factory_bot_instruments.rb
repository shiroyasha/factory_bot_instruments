require "factory_girl_instruments/version"

require "factory_girl"
require "active_record"

require_relative "factory_girl_instruments/benchmarking"
require_relative "factory_girl_instruments/tracing"

FactoryGirl.extend(FactoryGirlInstruments::Benchmarking)
FactoryGirl.extend(FactoryGirlInstruments::Tracing)

module FactoryGirlInstruments

  def self.benchmark_report(options = {})
    options = { :progress => true }.merge(options)

    FactoryGirl.benchmark_all(options).each do |benchmark|
      puts benchmark
    end
  end

end
