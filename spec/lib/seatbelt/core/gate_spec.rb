require 'spec_helper'

describe Seatbelt::Gate do
  class ImplementsA
    include Seatbelt::Gate
  end

  describe "class methods" do

    it "provides #implement" do
      expect(ImplementsA).to respond_to(:implement)
    end

    it "provides #implement_class" do
      expect(ImplementsA).to respond_to(:implement_class)
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

    describe "#implement_class" do
      before(:all) do

      end

      context "and given a method config array for :only" do

        it "mass registers logic methods for a module namespace" do
          expect do
            ImplementsA.class_eval do
              implement_class "Vagalo::Airport",
                              :only => [{:clean_seat_count => {:as => "#seats"}}]


              def clean_seat_count;end
            end
          end.to change { Seatbelt::Terminal.luggage.size }.by(1)

          config = Seatbelt::Terminal.luggage.last
          expect(config[:namespace]).to eq "Vagalo::Airport"
          expect(config[:scope]).to eq :instance
          expect(config[:implemented_as]).to eq :seats
        end

      end

      context "and given a method config hash for :only" do

        it "registers a logic method with module namespace and instance method" do
          expect do
            ImplementsA.class_eval do
              implement_class "Vagalo::Airport",
                              :only => {:delays => {:as => ".fetch_delays"}}

              def delays(days);end
            end
          end.to change { Seatbelt::Terminal.luggage.size }.by(1)

          config = Seatbelt::Terminal.luggage.last
          expect(config[:namespace]).to eq "Vagalo::Airport"
          expect(config[:scope]).to eq :class
          expect(config[:implemented_as]).to eq :fetch_delays
        end

      end

    end

  end

  describe "instance methods" do

    it "provides #proxy_object" do
      expect(ImplementsA.new).to respond_to(:proxy_object)
    end

    describe "#proxy" do

      before do

        class ProxySample
          include Seatbelt::Document
          include Seatbelt::Ghost

          attribute :name, String

          api_method :bar
          api_method :foo

        end

        ImplementsA.class_eval do

          attr_accessor :airport_codes

          def implement_bar
            airport_codes = 12
            return [proxy,self]
          end
          implement :implement_bar, :as => "ProxySample#bar"

          def implement_foo
            return [proxy,self]
          end
          implement :implement_foo, :as => "ProxySample#foo"

        end

      end

      it "will not be the same object for multiple API class instances" do
        first   = ProxySample.new(:name => "Foo")
        second  = ProxySample.new(:name => "Bar")

        first_proxy, first_imp   = first.bar
        second_proxy, second_imp  = second.bar

        expect(first_proxy).not_to be second_proxy
        expect(first_proxy.name).to eq "Foo"
        expect(second_proxy.name).to eq "Bar"
      end

    end

  end
end