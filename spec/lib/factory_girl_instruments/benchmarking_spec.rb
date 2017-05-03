require "spec_helper"

RSpec.describe FactoryGirlInstruments::Benchmarking do

  describe ".benchmark_all" do
    it "keeps the db clean" do
      expect { FactoryGirl.benchmark_all }.to_not change { User.count }
    end

    it "benchmarks all factories" do
      benchmarked_factories = FactoryGirl.benchmark_all.map(&:factory)

      expect(benchmarked_factories).to include(:user)
      expect(benchmarked_factories).to include(:article)
    end

    it "benchmarks by create, build, and build_stubbed by default" do
      benchmarked_methods = FactoryGirl.benchmark_all.map(&:method)

      expect(benchmarked_methods).to include(:create)
      expect(benchmarked_methods).to include(:build_stubbed)
      expect(benchmarked_methods).to include(:build)
    end

    describe "limiting factory girl methods" do
      it "runs only passed factory girl methods" do
        benchmarked_methods = FactoryGirl.benchmark_all(:methods => [:create, :build]).map(&:method)

        expect(benchmarked_methods).to include(:create)
        expect(benchmarked_methods).to include(:build)

        expect(benchmarked_methods).to_not include(:build_stubbed)
      end
    end

    describe "skipping factories" do
      it "skipps passed factories" do
        benchmarked_factories = FactoryGirl.benchmark_all(:except => [:article]).map(&:factory)

        expect(benchmarked_factories).to include(:user)
        expect(benchmarked_factories).to_not include(:article)
      end
    end
  end

  describe ".benchmark" do
    it "keeps the db clean" do
      expect { FactoryGirl.benchmark(:user) }.to_not change { User.count }
    end

    it "returns the duration in seconds" do
      expect(FactoryGirl.benchmark(:user)).to be_instance_of(FactoryGirlInstruments::Benchmark)
    end

    it "measures 'FactoryGirl.create' by default" do
      expect(FactoryGirl).to receive(:create)

      FactoryGirl.benchmark(:user)
    end

    it "can measure 'FactoryGirl.build'" do
      expect(FactoryGirl).to receive(:build)

      FactoryGirl.benchmark(:user, :method => :build)
    end

    it "can measure 'FactoryGirl.build_stubbed'" do
      expect(FactoryGirl).to receive(:build_stubbed)

      FactoryGirl.benchmark(:user, :method => :build_stubbed)
    end
  end
end
