require 'spec_helper'

describe "Seatbelt::TravelAgent" do

  describe "class methods" do

    it "provides #tell_me" do
      expect(Seatbelt::TravelAgent).to respond_to(:tell_me)
    end

    describe "#tell_me" do

      before(:all) do
        class HotelSampleTape < Seatbelt::Tape
          translate /Show me (\d+) of the (\w+) in (\w+)/ do |sentence,
                                                              count,
                                                              price_type,
                                                              location|


            tape_deck.to_s
          end

          translate /(\d+) (persons|person) want to travel for (\d+) (days|weeks|months) beginning at (.+) to (\w+)./i do |question,data|
            []
          end

        end
        Seatbelt::Models::Hotel.class_eval { include Seatbelt::TapeDeck }
        Seatbelt::Models::Hotel.add_tape HotelSampleTape
      end

      it "query starts with responsible model" do
        query   = "Hotel: Show me 2 of the cheapest in London"
        result  = Seatbelt::TravelAgent.tell_me query
        expect(result).to eq "Seatbelt::Models::Hotel"
      end

      context "if responsible model name is omitted" do

        before(:all) do
          Seatbelt::Models::Offer.class_eval { include Seatbelt::TapeDeck }
          class OfferSampleTape < Seatbelt::Tape
            translate /Find hotels in (\w+)/ do |sentence, city|
              tape_deck
            end
          end
          Seatbelt::Models::Offer.add_tape OfferSampleTape
        end

        it "then calls the Offer model" do
          expect(Seatbelt::TravelAgent.tell_me "Find hotels in Barcelona").to eq\
                                                        Seatbelt::Models::Offer
        end

      end

      it "gets the tape that responds to the query and plays the tape" do
        query = "Hotel: 3 persons want to travel for 10 days beginning at next friday to Finnland."
        result = Seatbelt::TravelAgent.tell_me query

        expect(result).to be_instance_of Array
      end

    end


  end

end