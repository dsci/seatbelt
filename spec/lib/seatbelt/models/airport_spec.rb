require 'spec_helper'

describe Seatbelt::Models::Airport do

  it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #ident" do
      expect(subject).to respond_to(:ident)
    end

    it "includes #iata_code" do
      expect(subject).to respond_to(:iata_code)
    end

    it "includes #type" do
      expect(subject).to respond_to(:type)
    end

    it "includes #name" do
      expect(subject).to respond_to(:name)
    end

    it "includes #lcode" do
      expect(subject).to respond_to(:lcode)
    end
    
    it "includes #latitude" do
      expect(subject).to respond_to(:latitude)
    end

    it "includes #longitude" do
      expect(subject).to respond_to(:longitude)
    end

    it "includes #gps_code" do
      expect(subject).to respond_to(:gps_code)
    end

    it "includes #scheduled_service" do
      expect(subject).to respond_to(:scheduled_service)
    end 

    it "includes #home_link" do
      expect(subject).to respond_to(:home_link)
    end 

    it "includes #wikipedia_link" do
      expect(subject).to respond_to(:wikipedia_link)
    end   

    describe "#ident" do

      before{ subject.ident = "NTGA"}

      it "is a String" do
        expect(subject.ident).to be_instance_of String
      end

    end

    describe "#iata_code" do

      before{ subject.iata_code = "AAA"}

      it "is a String" do
        expect(subject.iata_code).to be_instance_of String
      end

    end

    describe "#type" do

      before{ subject.type = "medium_airport" }

      it "is a String" do
        expect(subject.type).to be_instance_of String
      end

    end

    describe "#name" do

      before{ subject.name = "Anaa Airport" }

      it "is a String" do
        expect(subject.name).to be_instance_of String
      end

    end

    describe "#lcode" do

      before{ subject.lcode = "PF" }

      it "is a String" do
        expect(subject.lcode).to be_instance_of String
      end

    end

    describe "#latitude" do

      before{ subject.latitude = "-17.35" }

      it "is a String" do
        expect(subject.latitude).to be_instance_of Float
      end
    end

    describe "#longitude" do

      before{ subject.longitude = "-145.50" }

      it "is a Array" do
        expect(subject.longitude).to be_instance_of Float
      end

    end

    describe "gps_code" do

      before{ subject.gps_code = "NTGA"}

      it "is an String" do
        expect(subject.gps_code).to be_instance_of String
      end

    end

    describe "scheduled_service" do

      before{ subject.scheduled_service = "1"}

      it "is a String" do
        expect(subject.scheduled_service).to be_instance_of TrueClass
      end

    end

    describe "home_link" do

      before{ subject.home_link = "http://www.aal.dk"}

      it "is an String" do
        expect(subject.home_link).to be_instance_of String
      end

    end

    describe "wikipedia_link" do

      before{ subject.wikipedia_link = "http://en.wikipedia.org/wiki/Anaa_Airport"}

      it "is an String" do
        expect(subject.wikipedia_link).to be_instance_of String
      end

    end

  end

end