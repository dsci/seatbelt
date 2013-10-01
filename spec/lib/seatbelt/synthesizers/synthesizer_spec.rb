require 'spec_helper'

describe Seatbelt::Synthesizer do
  before(:all) do
    class ApiFromSynthesize
      include Seatbelt::Document
      include Seatbelt::Ghost

      attribute :age, Integer
      attribute :name, String
    end

    class ImplementationSynthesize
      include Mongoid::Document

      field :age, :type => Integer
    end

    class SynthesizeWrapper
      include Seatbelt::Synthesizer

      def synthesizable_attributes
        [:age]
      end
    end
  end

  describe "#instance_methods" do
    let(:implementation) { ImplementationSynthesize.new }
    let(:instance) do
      SynthesizeWrapper.new(ApiFromSynthesize, implementation)
    end

    it "provides #synthesize" do
      expect(instance).to respond_to(:synthesize)
    end

    it "expects a #synthesizable_attributes method" do
      class InvalidSynthesizer
        include Seatbelt::Synthesizer
      end

      synthesizer = InvalidSynthesizer.new(ApiFromSynthesize, implementation)

      expect do
        synthesizer.synthesize
      end.to \
      raise_error(Seatbelt::Errors::SynthesizeableAttributesNotImplementedError,
                  "Your synthesizer has to implement #synthesizable_attributes.")

    end

    describe "#synthesize" do

      it "sets the attributes of the proxy object and vice versa" do
        implementation.stub(:proxy).and_return(ApiFromSynthesize.new)
        implementation.class.stub(:get_synthesize_map).and_return({})
        instance.synthesize

        implementation.proxy.age = 12
        expect(implementation.age).to eq implementation.proxy.age

        implementation.age = 44
        expect(implementation.proxy.age).to eq implementation.age
      end

      describe "and a #synthesize_map" do
        before(:all) do

          class ImplementationSynthesizeWithDifferentAttributes
            include Mongoid::Document

            field :lc_age,          :type => Integer
            field :prx_identifier,  :type => String

            def self.synthesize_map
              {
                :age  => :lc_age,
                :name => :prx_identifier
              }
            end

            SynthesizeWrapper.class_eval do
              def synthesizable_attributes
                [:lc_age, :prx_identifier]
              end
            end
          end

        end

        it "sets the attributes of the proxy object and vice versa" do
          implementation2 = ImplementationSynthesizeWithDifferentAttributes.new
          instance = SynthesizeWrapper.new(ApiFromSynthesize, implementation2)
          implementation2.stub(:proxy).and_return(ApiFromSynthesize.new)

          instance.synthesize
          implementation2.proxy.age   = 12
          implementation2.proxy.name  = "Kafka"
          expect(implementation2.lc_age).to eq implementation2.proxy.age
          expect(implementation2.prx_identifier).to eq implementation2.proxy.name

          implementation2.lc_age = 44
          expect(implementation2.proxy.age).to eq implementation2.lc_age
          implementation2.prx_identifier = "Roberts"
          expect(implementation2.proxy.name).to eq implementation2.prx_identifier
        end
      end
    end

  end
end