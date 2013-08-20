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

      <<-DOC
      it "#validates_presence_of" do
        expect(SampleDocument).to respond_to(:validates_presence_of)
      end
      DOC

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

          end

          class ImplementsSampleDocument
            include Seatbelt::Gate

            def implementation_method
              #proxy.call("name=", "Winter")
              return proxy.call(:name)
            end
            implement :implementation_method, :as => "SampleDocument#foo"
          end
        end

        it "evaluates the attributes value" do
          document = SampleDocument.new(:name => "Winter")
          expect(document.foo).to eq "Winter"
        end
      end
    end

  end
end