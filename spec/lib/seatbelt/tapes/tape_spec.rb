require 'spec_helper'

describe Seatbelt::Tape do

  describe "class methods" do

    it "provides #answers" do
      expect(Seatbelt::Tape).to respond_to(:answers)
    end

    it "provides #translate" do
      expect(Seatbelt::Tape).to respond_to(:translate)
    end

    it "provides #listen_to" do
      expect(Seatbelt::Tape).to respond_to(:listen_to)
    end

    it "provides #play_tape" do
      expect(Seatbelt::Tape).to respond_to(:play_tape)
    end

    it "provides #tape_deck" do
      expect(Seatbelt::Tape).to respond_to(:tape_deck)
    end

    describe "#answers" do

      before(:all) do
        class RSpecTape < Seatbelt::Tape;end
      end

      it "is a store to hold answers for the tape" do
        expect do
          RSpecTape.class_eval do
            translate /hey/ do |sentence|
            end
          end
        end.to change{ RSpecTape.answers.size }.by(1)
      end

    end

    describe "#translate" do

      context "playing other tapes" do

        before(:all) do
          class FooTape < Seatbelt::Tape

            translate /Hello Howdie!/ do |sentence, data|
              play_tape(BarTape, :section => "No man!")
            end

            translate /Gimme (\d+) beers!/ do |count_of_beer|
              play_tape(:section => "Want the bill for #{count_of_beer} beer")
            end

            translate /Want the bill for (\d+) beer/ do |beer_amount|
              costs_of_beer = 2
              sum           = 2 * beer_amount.to_i
              "Cost #{sum} bucks."
            end

            translate /Send me (\d+) postcards from (\w+)/ do |sentence,
                                                               post_card_count,
                                                               location|

              play_tape(PostcardTape, :section => "send #{post_card_count}")
            end
          end

          class BarTape < Seatbelt::Tape

            translate  /No man!/ do |sentence, data|
              "My query is: #{sentence}"
            end

          end

          class PostcardTape < Seatbelt::Tape

          end

          class Foo
            include Seatbelt::TapeDeck

            use_tapes FooTape,
                      BarTape
          end
        end

        it "calls the same tape if tape name is omitted" do
          result = Foo.respond("Gimme 2 beers!")
          expect(result).to eq("Cost 4 bucks.")
        end

        it "calls an answer of a different tape if tape name is given" do
          result = Foo.respond("Hello Howdie!")
          expect(result).to eq "My query is: No man!"
        end

        it "raises an error if a unknow tape is called" do
          expect do
            Foo.respond("Send me 2 postcards from London")
          end.to raise_error(Seatbelt::Errors::NoTapeFoundForQueryError)
        end

      end

    end

  end

end