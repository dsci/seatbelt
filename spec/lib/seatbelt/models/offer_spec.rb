require 'spec_helper'

describe Seatbelt::Models::Offer do

  #it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #price" do
      expect(subject).to respond_to(:price)
    end

    it "includes #lcode" do
      expect(subject).to respond_to(:lcode)
    end

    it "includes #lname" do
      expect(subject).to respond_to(:lname)
    end

    it "includes #gidd" do
      expect(subject).to respond_to(:gidd)
    end

    it "includes #travel_days" do
      expect(subject).to respond_to(:travel_days)
    end

    it "includes #catering" do
      expect(subject).to respond_to(:catering)
    end

    it "includes #room_type" do
      expect(subject).to respond_to(:room_type)
    end

    it "includes #air_temperature" do
      expect(subject).to respond_to(:air_temperature)
    end

    it "includes #water_temperature" do
      expect(subject).to respond_to(:water_temperature)
    end

    it "includes #flight_duration" do
      expect(subject).to respond_to(:flight_duration)
    end

    it "includes #rating" do
      expect(subject).to respond_to(:rating)
    end

    it "includes #rating_count" do
      expect(subject).to respond_to(:rating_count)
    end

    describe "#price" do

      before{ subject.price = "762" }

      it "is a Float" do
        expect(subject.price).to be_instance_of Float
      end

    end

    describe "#lcode" do

      before{ subject.lcode = "PMI" }

      it "is a String" do
        expect(subject.lcode).to be_instance_of String
      end

    end

    describe "#lname" do

      before{ subject.lname = "Spanien" }

      it "is a String" do
        expect(subject.lname).to be_instance_of String
      end

    end

    describe "#lname" do

      before{ subject.gidd = "67356 7729" }

      it "is a String" do
        expect(subject.gidd).to be_instance_of String
      end

    end

    describe "#travel_days" do

      before{ subject.travel_days = "12" }

      it "is a Integer" do
        expect(subject.travel_days).to be_instance_of Fixnum
      end

    end

    describe "#catering" do

      before{ subject.catering = "Halbpension" }

      it "is a String" do
        expect(subject.catering).to be_instance_of String
      end

    end

    describe "#catering" do

      before{ subject.room_type = "Studio" }

      it "is a String" do
        expect(subject.room_type).to be_instance_of String
      end

    end

    describe "#air_temperature" do

      before{ subject.air_temperature = "34.4" }

      it "is a Float" do
        expect(subject.air_temperature).to be_instance_of Float
      end

    end

    describe "#water_temperature" do

      before{ subject.water_temperature = "23.1" }

      it "is a Float" do
        expect(subject.water_temperature).to be_instance_of Float
      end

    end

    describe "#flight_duration" do

      before{ subject.flight_duration = "11" }

      it "is a Integer" do
        expect(subject.flight_duration).to be_instance_of Fixnum
      end

    end

    describe "#rating" do

      before{ subject.rating = "5" }

      it "is a Integer" do
        expect(subject.rating).to be_instance_of Fixnum
      end

    end

    describe "#rating_count" do

      before{ subject.rating_count = "11" }

      it "is a Integer" do
        expect(subject.rating_count).to be_instance_of Fixnum
      end

    end


  end
end