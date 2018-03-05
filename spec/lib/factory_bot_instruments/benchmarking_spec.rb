require "spec_helper"

RSpec.describe FactoryBotInstruments::Benchmarking do

  describe ".benchmark_all" do
    it "keeps the db clean" do
      expect { FactoryBot.benchmark_all }.to_not change { User.count }
    end

    it "benchmarks all factories" do
      benchmarked_factories = FactoryBot.benchmark_all.map(&:factory)

      expect(benchmarked_factories).to include(:user)
      expect(benchmarked_factories).to include(:article)
    end

    it "benchmarks by create, build, and build_stubbed by default" do
      benchmarked_methods = FactoryBot.benchmark_all.map(&:method)

      expect(benchmarked_methods).to include(:create)
      expect(benchmarked_methods).to include(:build_stubbed)
      expect(benchmarked_methods).to include(:build)
    end

    describe "limiting factory bot methods" do
      it "runs only passed factory bot methods" do
        benchmarked_methods = FactoryBot.benchmark_all(:methods => [:create, :build]).map(&:method)

        expect(benchmarked_methods).to include(:create)
        expect(benchmarked_methods).to include(:build)

        expect(benchmarked_methods).to_not include(:build_stubbed)
      end
    end

    describe "skipping factories" do
      it "skipps passed factories" do
        benchmarked_factories = FactoryBot.benchmark_all(:except => [:article]).map(&:factory)

        expect(benchmarked_factories).to include(:user)
        expect(benchmarked_factories).to_not include(:article)
      end
    end
  end

  describe ".benchmark" do
    it "keeps the db clean" do
      expect { FactoryBot.benchmark(:user) }.to_not change { User.count }
    end

    it "returns the duration in seconds" do
      expect(FactoryBot.benchmark(:user)).to be_instance_of(FactoryBotInstruments::Benchmark)
    end

    it "measures 'FactoryBot.create' by default" do
      expect(FactoryBot).to receive(:create)

      FactoryBot.benchmark(:user)
    end

    it "can measure 'FactoryBot.build'" do
      expect(FactoryBot).to receive(:build)

      FactoryBot.benchmark(:user, :method => :build)
    end

    it "can measure 'FactoryBot.build_stubbed'" do
      expect(FactoryBot).to receive(:build_stubbed)

      FactoryBot.benchmark(:user, :method => :build_stubbed)
    end
  end
end
