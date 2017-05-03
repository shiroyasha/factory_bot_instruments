require "spec_helper"

module IOHelper
  def self.capture(&block)
    begin
      $stdout = StringIO.new
      yield
      result = $stdout.string
    ensure
      $stdout = STDOUT
    end

    result
  end
end

RSpec.describe FactoryGirlInstruments do
  it "has a version number" do
    expect(FactoryGirlInstruments::VERSION).not_to be_nil
  end

  describe ".benchmark_report" do
    it "keeps the db clean" do
      expect { FactoryGirlInstruments.benchmark_report }.to_not change { User.count }
    end

    it "prints the benchmark on STDOUT" do
      output = IOHelper.capture { FactoryGirlInstruments.benchmark_report }

      output.split("\n") do |line|
        expect(line).to match(/\d+.\d+s\: FactoryGirl\..+\(\:.+\)/)
      end
    end
  end
end
