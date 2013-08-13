require 'spec_helper'

describe Seatbelt::Gate do
  class ImplementsA
    include Seatbelt::Gate
  end

  describe "class methods" do

    it "provides #implement" do
      expect(ImplementsA).to respond_to(:implement)
    end

    describe "#implement" do

      it "registers a logic method the the terminal" do
        expect do
          ImplementsA.class_eval do
            def fetch_flight_time; end
            implement :fetch_flight_time, :as => "A.flight_time"
          end
        end.to change{ Seatbelt::Terminal.luggage.size }.by(1)

        config = Seatbelt::Terminal.luggage.last

        expect(config).to have_key(:method)
        expect(config).to have_key(:implemented_as)
        expect(config).to have_key(:namespace)
        expect(config).to have_key(:scope)

        expect(config[:implemented_as]).to eq :flight_time
        expect(config[:method]).to be_a_kind_of(Method)
        expect(config[:namespace]).to eq "A"
        expect(config[:scope]).to eq :class
      end

      it "registers a logic method with module namespace and instance method" do
        expect do
          ImplementsA.class_eval do
            def check_flight_to(destination); end
            implement :check_flight_to, :as => "Vagalo::Airport#book_flight_to"
          end
        end.to change { Seatbelt::Terminal.luggage.size }.by(1)

        config = Seatbelt::Terminal.luggage.last

        expect(config[:namespace]).to eq "Vagalo::Airport"
        expect(config[:scope]).to eq :instance
        expect(config[:implemented_as]).to eq :book_flight_to

      end

    end

  end
end