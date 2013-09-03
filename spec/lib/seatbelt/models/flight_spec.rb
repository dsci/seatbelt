require 'spec_helper'

describe Seatbelt::Models::Flight do

  it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #day_of_unbound_flight" do
      expect(subject).to respond_to(:day_of_unbound_flight)
    end

    it "includes #day_of_return_flight" do
      expect(subject).to respond_to(:day_of_return_flight)
    end

    it "includes #return_flight_at" do
      expect(subject).to respond_to(:return_flight_at)
    end

    it "includes #outbound_flight_at" do
      expect(subject).to respond_to(:outbound_flight_at)
    end

    it "includes #trip_length" do
      expect(subject).to respond_to(:trip_length)
    end

    it "includes #destination" do
      expect(subject).to respond_to(:destination)
    end

    it "includes #price_per_person" do
      expect(subject).to respond_to(:price_per_person)
    end

    it "includes #overall_journey_price" do
      expect(subject).to respond_to(:overall_journey_price)
    end

    it "includes #ref" do
      expect(subject).to respond_to(:ref)
    end

    it "includes #lc" do
      expect(subject).to respond_to(:lc)
    end

    it "includes #travel_type" do
      expect(subject).to respond_to(:travel_type)
    end

    it "includes #duration_of_outbound_flight" do
      expect(subject).to respond_to(:duration_of_outbound_flight)
    end

    it "includes #duration_of_return_flight" do
      expect(subject).to respond_to(:duration_of_return_flight)
    end

    it "includes #outbound_flight_code" do
      expect(subject).to respond_to(:outbound_flight_code)
    end

    it "includes #return_flight_code" do
      expect(subject).to respond_to(:return_flight_code)
    end

    describe "#day_of_unbound_flight" do

      before{ subject.day_of_unbound_flight = "FRIDAY"}

      it "is a String" do
        expect(subject.day_of_unbound_flight).to be_instance_of String
      end

    end

    describe "#day_of_return_flight" do

      before{ subject.day_of_return_flight = "SUNDAY" }

      it "is a String" do
        expect(subject.day_of_return_flight).to be_instance_of String
      end

    end

    describe "#return_flight_at" do

      before{ subject.return_flight_at = "2013-08-09"}

      it "is a date" do
        expect(subject.return_flight_at).to be_instance_of Date
      end

    end

    describe "#outbound_flight_at" do

      before{ subject.outbound_flight_at = "2013-09-13" }

      it "is a date" do
        expect(subject.outbound_flight_at).to be_instance_of Date
      end

    end

    describe "#trip_length" do

      before{ subject.trip_length = "6" }

      it "is a Integer" do
        expect(subject.trip_length).to be_instance_of Fixnum
      end

    end

    describe "#destination" do

      before{ subject.destination = "London" }

      it "is a String" do
        expect(subject.destination).to be_instance_of String
      end

    end

    describe "#price_per_person" do

      before{ subject.price_per_person = "65493" }

      it "is a Float" do
        expect(subject.price_per_person).to be_instance_of Float
      end

    end

    describe "#overall_journey_price" do

      before{ subject.overall_journey_price = "543" }

      it "is a Float" do
        expect(subject.overall_journey_price).to be_instance_of Float
      end

    end

    describe "#ref" do

      before{ subject.ref = "TUI Flights" }

      it "is a String" do
        expect(subject.ref).to be_instance_of String
      end

    end

    describe "#lc" do

      before{ subject.lc = "SUPR" }

      it "is a String" do
        expect(subject.lc).to be_instance_of String
      end

    end

    describe "#travel_type" do

      before{ subject.travel_type = "SF" }

      it "is a String" do
        expect(subject.travel_type).to be_instance_of String
      end

    end

    describe "#outbound_flight_code" do

      before{ subject.outbound_flight_code = "SF" }

      it "is a String" do
        expect(subject.outbound_flight_code).to be_instance_of String
      end

    end

    describe "#return_flight_code" do

      before{ subject.return_flight_code = "SF" }

      it "is a String" do
        expect(subject.return_flight_code).to be_instance_of String
      end

    end

  end

end