require "factory_bot_instruments/version"

require "factory_bot"
require "active_record"

require_relative "factory_bot_instruments/benchmarking"
require_relative "factory_bot_instruments/tracing"

FactoryBot.extend(FactoryBotInstruments::Benchmarking)
FactoryBot.extend(FactoryBotInstruments::Tracing)

module FactoryBotInstruments

  def self.benchmark_report(options = {})
    options = { :progress => true }.merge(options)

    FactoryBot.benchmark_all(**options).each do |benchmark|
      puts benchmark
    end
  end

end
