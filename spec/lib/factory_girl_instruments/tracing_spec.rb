require "spec_helper"

RSpec.describe FactoryGirlInstruments::Tracing do

  describe ".trace" do
    it "prints the factory girl steps" do
      FactoryGirl.trace do
        FactoryGirl.create(:comment)
      end
    end
  end

end
