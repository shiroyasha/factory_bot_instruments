$FACTORY_BOT_INSTRUMENTS_TRACING = false
$FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH = 0

# monkey patch Factory#run
module FactoryBot
  class Factory
    alias_method :original_run, :run

    def run(build_strategy, overrides, &block)
      if $FACTORY_BOT_INSTRUMENTS_TRACING
        depth     = "|  " * $FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH
        signature = "#{build_strategy} \e[32m:#{@name}\e[0m"
        start     = Time.now

        puts "#{depth}┌ (start) #{signature}"
        $FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH += 1
      end

      result = original_run(build_strategy, overrides, &block)

      if $FACTORY_BOT_INSTRUMENTS_TRACING
        duration = format("%4.3fs", Time.now - start)
        puts "#{depth}└ (finish) #{signature} [#{duration}]"

        $FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH -= 1
      end

      result
    end
  end
end

module FactoryBotInstruments
  module TracingHelpers
    def self.uncolorize(string)
      string.gsub(/\033\[\d+m/, "")
    end

    def self.sql_tracer(active)
      return yield unless active

      begin
        stdout_log = Logger.new($stdout)

        stdout_log.formatter = proc do |severity, datetime, progname, msg|
          depth = "|  " * ($FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH - 1)

          msg = FactoryBotInstruments::TracingHelpers.uncolorize(msg)
          msg = msg.strip
          msg = msg.gsub(/^SQL /, "") # remove SQL prefix

          "#{depth}|  \e[36m#{msg}\e[0m\n"
        end

        standard_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = stdout_log

        yield
      ensure
        ActiveRecord::Base.logger = standard_logger
      end
    end
  end

  module Tracing
    def trace(sql: true)
      result = nil

      begin
        $FACTORY_BOT_INSTRUMENTS_TRACING = true
        $FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH = 0

        FactoryBotInstruments::TracingHelpers.sql_tracer(sql) do
          result = yield
        end
      ensure
        $FACTORY_BOT_INSTRUMENTS_TRACING = false
        $FACTORY_BOT_INSTRUMENTS_TRACING_DEPTH = 0
      end

      result
    end
  end
end
