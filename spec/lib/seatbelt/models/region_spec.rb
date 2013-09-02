require 'spec_helper'

describe Seatbelt::Models::Region do

  it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #name" do
      expect(subject).to respond_to(:name)
    end

    it "includes #giata_id" do
      expect(subject).to respond_to(:giata_id)
    end

    it "includes #iso_code_country" do
      expect(subject).to respond_to(:iso_code_country)
    end

    it "includes #minimum_price" do
      expect(subject).to respond_to(:minimum_price)
    end

    it "includes #flight_duration" do
      expect(subject).to respond_to(:flight_duration)
    end

    it "includes #air_temperature" do
      expect(subject).to respond_to(:air_temperature)
    end

    it "includes #water_temperature" do
      expect(subject).to respond_to(:water_temperature)
    end

    describe "#name" do

      before{ subject.name = "Kasachstan" }

      it "is a String" do
        expect(subject.name).to be_instance_of String
      end

    end

    describe "#giata_id" do

      before{ subject.giata_id = "269 638 639 640" }

      it "is a String" do
        expect(subject.giata_id).to be_instance_of String
      end

    end

    describe "#iso_code_country" do

      before{ subject.iso_code_country = "CAN" }

      it "is a String" do
        expect(subject.iso_code_country).to be_instance_of String
      end
    end

    describe "#minimum_price" do

      before{ subject.minimum_price = "12.32" }

      it "is a Float" do
        expect(subject.minimum_price).to be_instance_of Float
      end

    end

    describe "flight_duration" do

      before{ subject.flight_duration = "8"}

      it "is an Integer" do
        expect(subject.flight_duration).to be_instance_of Fixnum
      end

    end

    describe "air_temperature" do

      before{ subject.air_temperature = "23"}

      it "is a String" do
        expect(subject.air_temperature).to be_instance_of String
      end

    end

    describe "water_temperature" do

      before{ subject.water_temperature = "21" }

      it "is a String" do
        expect(subject.water_temperature).to be_instance_of String
      end

    end
  end

end