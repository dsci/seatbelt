require 'spec_helper'

describe Seatbelt::Document do

  describe "included in a class" do

    before(:all) do
      class SampleDocument
        include Seatbelt::Document
      end
    end

    describe "provides class methods" do

      it "#attribute" do
        expect(SampleDocument).to respond_to(:attribute)
      end


      it "#validates_presence_of" do
        expect(SampleDocument).to respond_to(:validates_presence_of)
      end

      it "#provides #has_many" do
        expect(SampleDocument).to respond_to(:has_many)
      end

      it "provides #has" do
        expect(SampleDocument).to respond_to(:has)
      end

    end

    describe "defining attributes" do
      before(:all) do
        SampleDocument.class_eval do
          attribute :name,    String
          attribute :length,  Integer, :default => 120
        end
      end

      let(:document){ SampleDocument.new }

      it "returns the value type" do
        document.name = "API-doc.pdf"
        expect(document.name).to be_instance_of String
        expect(document.length).to be_instance_of Fixnum
        expect(document.length).to be 120

      end

      it "returns the value after setting it" do
        name          = "API-doc.pdf"
        document.name = name
        expect(document.name).to eq name
      end

      describe "accessing attributes in implementation classes" do

        before(:all) do
          SampleDocument.class_eval do
            include Seatbelt::Ghost
            api_method :foo

            api_method :bar, :scope => :class

            def self.class_foo
              "Summer"
            end
          end

          class ImplementsSampleDocument
            include Seatbelt::Gate

            def implementation_method
              #proxy.call("name=", "Winter")
              return proxy.call(:name)
            end
            implement :implementation_method, :as => "SampleDocument#foo"

            def self.another_implementation_method
              return proxy.call(:class_foo)
            end
            implement :another_implementation_method,
                      :as => "SampleDocument.bar",
                      :type => :class
          end
        end

        it "evaluates the attributes value" do
          document = SampleDocument.new(:name => "Winter")
          expect(document.foo).to eq "Winter"

          expect(SampleDocument.bar).to eq "Summer"
        end
      end
    end

    describe "validating of attributes" do
      before(:all) do
        SampleDocument.class_eval do
          attribute :name, String

          validates_presence_of :name
        end
      end

      describe "#validates_presence_of" do

        context "attribute is given" do

          it "then the model is valid" do
            document = SampleDocument.new(:name => "Peter")
            expect(document).to be_valid
          end

        end

        context "attribute is not given" do

          it "then the model isn't valid" do
            document = SampleDocument.new
            expect(document).to_not be_valid
          end

        end

      end
    end

    describe "defining associations" do

      describe "#has_many" do

        before(:all) do
          SampleDocument.class_eval do
            has_many :hotels, Seatbelt::Models::Hotel
          end
        end

        let(:document){ SampleDocument.new }

        it "returns an instance of array" do
          expect(document.hotels).to be_instance_of Seatbelt::Collections::Array
        end

        context "adding a model that isn't of required type" do

          it "raises a Seatbelt::Errors::TypeMissmatchError" do
            message = "An instance of Seatbelt::Models::Hotel awaited but "
            message += "get an instance of Seatbelt::Models::Region."
            expect do
              document.hotels << Seatbelt::Models::Region.new
            end.to raise_error Seatbelt::Errors::TypeMissmatchError, message
          end
        end

        context "adding a model that is of required type" do

          it "increases the association collection size" do
            expect do
              document.hotels << Seatbelt::Models::Hotel.new(:name => "Atlanta")
            end.to change{ document.hotels.size }.by(1)
          end

          context "by only adding an attribute hash" do

            it "increases the association collection size" do
              expect do
                document.hotels << {:name => "Westin"}
              end.to change{ document.hotels.size }.by(1)
            end

          end

        end

        context "add multiple #has_many associations" do

          before(:all) do
            SampleDocument.class_eval do
              has_many :offers, Seatbelt::Models::Offer
            end
          end

          it "passes validation for every #has_many definition" do
            document = SampleDocument.new
            expect do
              document.hotels << Seatbelt::Models::Hotel.new
            end.to change { document.hotels.size }.by(1)
            expect do
              document.offers << Seatbelt::Models::Offer.new
            end.to change { document.offers.size }.by(1)
          end

          it "raises an TypeMissmatchError if model isn't required type" do
            document = SampleDocument.new
            message = "An instance of Seatbelt::Models::Hotel awaited but "
            message += "get an instance of Seatbelt::Models::Region."
            expect do
              document.hotels << Seatbelt::Models::Region.new
            end.to raise_error Seatbelt::Errors::TypeMissmatchError, message
            message = "An instance of Seatbelt::Models::Offer awaited but "
            message += "get an instance of Seatbelt::Models::Region."
            expect do
              document.offers << Seatbelt::Models::Region.new
            end.to raise_error Seatbelt::Errors::TypeMissmatchError, message
          end

        end
      end

      describe "#has" do

        context "defining a reference without class" do
          before(:all) do
            SampleDocument.class_eval do
              has :flight
            end
          end

          let(:document){ SampleDocument.new }

          it "takes Seatbelt::Models namespace" do
            expect(document).to respond_to(:flight)
          end

          context "assigning the reference " do

            context "has instance then the getter" do
              it "returns the instance of guessed class" do
                document.flight = Seatbelt::Models::Flight.new
                expect(document.flight).to be_instance_of(Seatbelt::Models::Flight)
              end
            end

            context "has attribute hash" do
              it "returns the instance of guessed class" do
                document.flight = {:trip_length => 12}
                expect(document.flight).to be_instance_of(Seatbelt::Models::Flight)
              end
            end
          end
        end

        context "defining a reference with class" do
          before(:all) do
            class TrashBin
              include Seatbelt::Document

              attribute :empty, Boolean
            end
            SampleDocument.class_eval do
              has :trash_bin, TrashBin
            end
          end

          let(:document){ SampleDocument.new }

          it "takes the given class namespace" do
            expect(document).to respond_to(:trash_bin)
            document.trash_bin = TrashBin.new
            expect(document.trash_bin).to be_instance_of(TrashBin)
            document.trash_bin = {:emtpy => false}
            expect(document.trash_bin).to be_instance_of(TrashBin)
          end
        end
      end
    end
  end
end