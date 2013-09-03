require 'spec_helper'

describe Seatbelt::Models::Picture do

  it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #hotel_id" do
      expect(subject).to respond_to(:hotel_id)
    end

    it "includes #caption" do
      expect(subject).to respond_to(:caption)
    end

    it "includes #thumbnail_url" do
      expect(subject).to respond_to(:thumbnail_url)
    end

    it "includes #url" do
      expect(subject).to respond_to(:url)
    end

    it "includes #width" do
      expect(subject).to respond_to(:width)
    end
    
    it "includes #height" do
      expect(subject).to respond_to(:height)
    end

    it "includes #default_image" do
      expect(subject).to respond_to(:default_image)
    end

    it "includes #source" do
      expect(subject).to respond_to(:source)
    end  

    describe "#hotel_id" do

      before{ subject.hotel_id = "123456" }

      it "is a Integer" do
        expect(subject.hotel_id).to be_instance_of Fixnum
      end

    end

    describe "#caption" do

      before{ subject.caption = "AAA"}

      it "is a String" do
        expect(subject.caption).to be_instance_of String
      end

    end

    describe "#thumbnail_url" do

      before{ subject.thumbnail_url = "http://media.expedia.com/1000/picture.jpg" }

      it "is a String" do
        expect(subject.thumbnail_url).to be_instance_of String
      end

    end

    describe "#url" do

      before{ subject.url = "http://media.expedia.com/1000/big_picture.jpg" }

      it "is a String" do
        expect(subject.url).to be_instance_of String
      end

    end

    describe "#width" do

      before{ subject.width = 350 }

      it "is a Integer" do
        expect(subject.width).to be_instance_of Fixnum
      end

    end

    describe "#height" do

      before{ subject.height = 350 }

      it "is a Integer" do
        expect(subject.height).to be_instance_of Fixnum
      end
    end

    describe "#default_image" do

      before{ subject.default_image = "1" }

      it "is a Boolean" do
        expect(subject.default_image).to be_instance_of TrueClass
      end

    end

    describe "source" do

      before{ subject.source = "Expedia"}

      it "is an String" do
        expect(subject.source).to be_instance_of String
      end

    end

  end

end