require "spec_helper"


RSpec.describe FactoryBotInstruments do
  it "has a version number" do
    expect(FactoryBotInstruments::VERSION).not_to be_nil
  end

  describe ".benchmark_report" do
    it "keeps the db clean" do
      expect { FactoryBotInstruments.benchmark_report }.to_not change { User.count }
    end

    it "prints the benchmark on STDOUT" do
      output = IOHelper.capture do
        FactoryBotInstruments.benchmark_report(progress: false)
      end

      output.split("\n") do |line|
        expect(line).to match(/\d+.\d+s\: FactoryBot\..+\(\:.+\)/)
      end
    end
  end
end
