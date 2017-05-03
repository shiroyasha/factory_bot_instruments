require "spec_helper"

RSpec.describe FactoryGirlBenchmark do
  it "has a version number" do
    expect(FactoryGirlBenchmark::VERSION).not_to be_nil
  end

  describe ".run" do
    it "keeps the db clean" do
      expect { FactoryGirlBenchmark.run }.to_not change { User.count }
    end
  end

  describe ".benchmark" do
    it "keeps the db clean" do
      expect { FactoryGirlBenchmark.benchmark(:user) }.to_not change { User.count }
    end

    it "returns the duration in seconds" do
      expect(FactoryGirlBenchmark.benchmark(:user)).to be_instance_of(Float)
    end
  end
end
