require "spec_helper"

RSpec.describe FactoryBotInstruments::Tracing do

  describe ".trace" do
    context "default options" do
      before do
        @output = IOHelper.capture do
          FactoryBot.trace { FactoryBot.create(:comment) }
        end

        puts @output

        @output = FactoryBotInstruments::TracingHelpers.uncolorize(@output)
      end

      it "prints the factory bot steps" do
        expect(@output).to include("(start) create :comment")
        expect(@output).to include("(start) create :article")
        expect(@output).to include("(start) create :user")

        expect(@output).to include("(finish) create :comment")
        expect(@output).to include("(finish) create :article")
        expect(@output).to include("(finish) create :user")
      end

      it "prints SQL statements" do
        expect(@output).to include("INSERT INTO \"comments\"")
      end
    end

    context "without SQL logs" do
      before do
        @output = IOHelper.capture do
          FactoryBot.trace(:sql => false) { FactoryBot.create(:comment) }
        end

        puts @output

        @output = FactoryBotInstruments::TracingHelpers.uncolorize(@output)
      end

      it "prints the factory bot steps" do
        expect(@output).to include("(start) create :comment")
        expect(@output).to include("(start) create :article")
        expect(@output).to include("(start) create :user")

        expect(@output).to include("(finish) create :comment")
        expect(@output).to include("(finish) create :article")
        expect(@output).to include("(finish) create :user")
      end

      it "doesn't print SQL statements" do
        expect(@output).to_not include("INSERT INTO \"comments\"")
      end

    end
  end

end
