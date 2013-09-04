require 'spec_helper'

describe Seatbelt::TapeDeck  do

  describe "#class_methods" do

    before(:all) do
      class Sample
        include Seatbelt::TapeDeck
      end
    end

    it "provides #tapes" do
      expect(Sample).to respond_to(:tapes)
    end

    it "provides #use_tape" do
      expect(Sample).to respond_to(:use_tape)
    end

    it "provides #use_tapes" do
      expect(Sample).to respond_to(:use_tapes)
    end

    it "provides #add_tape" do
      expect(Sample).to respond_to(:add_tape)
    end

    it "provides #respond" do
      expect(Sample).to respond_to(:respond)
    end

    describe "#tapes" do

      let(:mock_tape){ double("ATape") }

      it "is a store to hold tapes for the class" do
        expect do
          Sample.tapes << mock_tape
        end.to change { Sample.tapes.size }.by(1)
      end

    end

    describe "#use_tape" do

      let(:sample_tape){ double("SampleTape") }

      it "adds a tape to the tape store for this class" do
        sample_tape.stub(:tape_deck=)
        sample_tape.stub(:tape_deck).and_return(nil)
        expect do
          Sample.use_tape sample_tape
        end.to change { Sample.tapes.size }.by(1)

      end

      it "a tape is not useable in multiple tapedecks" do
        sample_tape.stub(:tape_deck).and_return(Sample)
        class Sample2
          include Seatbelt::TapeDeck
        end
        expect do
          Sample2.use_tape sample_tape
        end.to raise_error(Seatbelt::Errors::MultipleTapeUsageDetectedError)
      end

      context "the tape is already in the tape store for this class" do

        before(:all) do
          class SampleTape < Seatbelt::Tape
          end
          Sample.instance_eval do
            self.instance_variable_set(:@tapes, [])
          end
          Sample.use_tape SampleTape
        end

        it "then it didn't add the tape again" do
          expect do
            Sample.use_tape SampleTape
          end.to_not change{ Sample.tapes.size }.by(1)
        end
      end

    end

    describe "#use_tapes" do

      before(:all) do
        class RegionTape < Seatbelt::Tape;end
        class HotelTape < Seatbelt::Tape;end
      end

      it "adds a bunch of tapes to the tape store for this class" do
        expect do
          Sample.use_tapes RegionTape, HotelTape
        end.to change{ Sample.tapes.size }.by(2)
      end

    end

    describe "#respond" do

      before(:all) do
        Sample.instance_eval do
          self.instance_variable_set(:@tapes, [])
        end

        class TestTape < Seatbelt::Tape
        end

        Sample.class_eval do
          use_tape TestTape
        end
      end

      it "finds an answer on the tapes for the class that matches a query" do
        TestTape.class_eval do
          translate /Call me (\w+) !/ do |sentence, name|
            name
          end
        end

        query   = "Call me Harry !"
        expect(Sample.respond(query)).to eq "Harry"
      end

      it "passes the original query as first param to the block" do
        TestTape.class_eval do
          translate /Super summer party at (\d+)/ do |sentence, data|
            sentence
          end
        end
        query2  = "Super summer party at 12.08.2014"
        expect(Sample.respond(query2)).to eq query2
      end

      it "passes the matched data as second param list to the block" do
        TestTape.class_eval do
          translate /Add (\d+) to (\d+) and divide it by (\d+)/ do |sentence,
                                                                        sum1,
                                                                        sum2,
                                                                        divider|
            result = sum1.to_i  + sum2.to_i
            result/divider.to_i
          end
        end
        query = "Add 5 to 11 and divide it by 2"
        result = Sample.respond(query)
        expect(result).to be_instance_of Fixnum
        expect(result).to eq 8
      end

      it "raises an error if no answer is found for the query" do
        expect do
          Sample.respond(%Q{Show me 2 hotels nearby London})
        end.to raise_error(Seatbelt::Errors::NoTapeFoundForQueryError)
      end

      context "translate block takes just one argument" do

        it "then the argument is not the query sentence" do
          TestTape.class_eval do
            translate /Finde für mich (\d+) Hotels nahe meiner aktuellen Position/ do |count|
              count.to_i
            end
          end

          query   = "Finde für mich 5 Hotels nahe meiner aktuellen Position"
          result  = Sample.answer(query)
          expect(result).to_not eq query
          expect(result).to eq 5
        end
      end

    end
  end

end