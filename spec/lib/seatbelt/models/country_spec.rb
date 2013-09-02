require 'spec_helper'

describe Seatbelt::Models::Country do

  it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #lcode" do
      expect(subject).to respond_to(:lcode)
    end

    it "includes #name" do
      expect(subject).to respond_to(:name)
    end

    it "includes #name_de" do
      expect(subject).to respond_to(:name_de)
    end

    it "includes #coordinates" do
      expect(subject).to respond_to(:coordinates)
    end

    it "includes #text_long" do
      expect(subject).to respond_to(:text_long)
    end

    it "includes #text_short" do
      expect(subject).to respond_to(:text_short)
    end   

    describe "#lcode" do

      before{ subject.lcode = "AF" }

      it "is a String" do
        expect(subject.lcode).to be_instance_of String
      end

    end

    describe "#name" do

      before{ subject.name = "Afganistan" }

      it "is a String" do
        expect(subject.name).to be_instance_of String
      end

    end

    describe "#name_de" do

      before{ subject.name_de = "Afganistan" }

      it "is a String" do
        expect(subject.name_de).to be_instance_of String
      end
    end

    describe "#coordinates" do

      before{ subject.coordinates = [[[1.54922199249273, 42.5244102478028], [1.54944801330566, 42.5238685607911]], [[1.54922199249273, 42.5244102478028], [1.54944801330566, 42.5238685607911]]] }

      it "is a Array" do
        expect(subject.coordinates).to be_instance_of Array
      end

    end

    describe "text_long" do

      before{ subject.text_long = "Test Text zum Land langer Text"}

      it "is an String" do
        expect(subject.text_long).to be_instance_of String
      end

    end

    describe "text_short" do

      before{ subject.text_short = "kurzer Text"}

      it "is a String" do
        expect(subject.text_short).to be_instance_of String
      end

    end

  end

end