require 'spec_helper'

describe Seatbelt::Ghost do

  describe "included in a class" do

    before(:all) do
      class Sample
        include Seatbelt::Ghost
      end

      module SampleWithNamespace
        class Sample
          include Seatbelt::Ghost
        end
      end
    end

    describe "provides class methods" do
      it "#api_method" do
        expect(Sample).to respond_to(:api_method)
      end

      it "#lookup_tbl" do
        expect(Sample).to respond_to(:lookup_tbl)
      end

      it "#enable_tunneling!" do
        expect(Sample).to respond_to(:enable_tunneling!)
      end

      it "#disable_tunneling!" do
        expect(Sample).to respond_to(:disable_tunneling!)
      end

      it "#interface" do
        expect(Sample).to respond_to(:interface)
      end

      it "#define" do
        expect(Sample).to respond_to(:define)
      end

      it "#define_property" do
        expect(Sample).to respond_to(:define_property)
      end

      it "#define_properties" do
        expect(Sample).to respond_to(:define_properties)
      end
    end

    describe "calling an instance API method" do

      before(:all) do
        Seatbelt.configure_gate do |config|
          config.method_directive_class     = "."
          config.method_directive_instance  = "#"
        end

        Sample.class_eval do
          api_method :sum_numbers, :args => [:a,:b]
        end

        class ImplementSample
          include Seatbelt::Gate

          def sum_numbers_implementation(a,b)
            a+b
          end
          implement :sum_numbers_implementation, :as => "Sample#sum_numbers"

        end

        SampleWithNamespace::Sample.class_eval do
          api_method :seat_count, :args => [:flight_number]
        end

        ImplementSample.class_eval do
          def seats(flight_number)
            188 if flight_number.eql?("F-1890n")
          end
          implement :seats, :as => "SampleWithNamespace::Sample#seat_count"
        end
      end

      context "that exists and is implemented" do

        it "evaluates the implementation method" do
          sample      = Sample.new
          next_sample = SampleWithNamespace::Sample.new
          expect(sample.sum_numbers(2,3)).to eq 5
          expect(next_sample.seat_count("F-1890n")).to eq 188
        end

        context "but isnt a API method" do
          before(:all) do
            Sample.class_eval do
              def multiply(a,b)
                return a*b
              end
            end
          end

          it "evaluates the method" do
            expect(Sample.new.multiply(2,2)).to eq 4
          end
        end

        context "but has wrong argument list" do

          it "raises an ArgumentError" do
            sample = Sample.new
            expect do
              sample.sum_numbers(1)
            end.to raise_error(ArgumentError)
          end
        end

        context "requires a block that isnt implemented" do

          before(:all) do
            Sample.class_eval do
              api_method  :configure_gateway,
                          :block_required => true
            end
          end

          it "raises Seatbelt::Errors::ApiMethodBlockRequiredError" do
            sample = Sample.new
            expect do
              sample.configure_gateway("hey")
            end.to raise_error(Seatbelt::Errors::ApiMethodBlockRequiredError)
          end

        end


      end

      context "that isnt defined and didn't exist" do

        it "raises Seatbelt::Errors::NoMethodError" do
          sample = Sample.new
          expect do
            sample.factorize(6)
          end.to raise_error(Seatbelt::Errors::NoMethodError)
        end

      end

      describe "defined with :interface directive" do
        before(:all) do
          class SampleWithInterface
            include Seatbelt::Ghost
            interface :instance do
              define :calc, :args => [:a, :b]
              define :factorize, :args => [:num]

              define_property :foo
              define_properties :bar,:foobar
            end

            interface :class do
              define :class_calc, :args => [:a,:b]
            end
          end


          class ImplementationSampleWithInterface
            include Seatbelt::Gate
            include Seatbelt::Document

            def implement_calc(a,b)
              a+b
            end
            implement :implement_calc,
                      :as => "SampleWithInterface#calc"
            implement :implement_calc,
                      :as => "SampleWithInterface.class_calc"

            attribute :implement_foo, Integer

            implement :implement_foo,
                      :as => "SampleWithInterface#foo"
            implement :"implement_foo=",
                      :as => "SampleWithInterface#foo="

            attribute :implement_bar, Integer

            implement :implement_bar,
                      :as => "SampleWithInterface#bar"
            implement :"implement_bar=",
                      :as => "SampleWithInterface#bar="

            attribute :implement_foobar, Integer

            implement :implement_foobar,
                      :as => "SampleWithInterface#foobar"
            implement :"implement_foobar=",
                      :as => "SampleWithInterface#foobar="

          end
        end

        context "instance method" do
          it "evaluates the method" do
            expect(SampleWithInterface.new.calc(5,32)).to eq 37
          end
        end

        context "class method" do
          it "evaluates the method" do
            expect(SampleWithInterface.class_calc(3,4)).to eq 7
          end
        end

        context "property" do

          context "on instance level" do

            it "evaluates the setter and getter methods" do
              sample_with_interface_instance        = SampleWithInterface.new
              sample_with_interface_instance.foo    = 12
              sample_with_interface_instance.bar    = 10
              sample_with_interface_instance.foobar = 11
              expect(sample_with_interface_instance.foo).to eq 12
              expect(sample_with_interface_instance.bar).to eq 10
              expect(sample_with_interface_instance.foobar).to eq 11
            end

          end

          context "on class level" do

            it "raises an PropertyOnClassLevelDefinedError" do
              expect do
                SampleWithInterface.class_eval do

                  interface :class do
                    define_property :class_foo
                  end
                end

              end.to raise_error(Seatbelt::Errors::PropertyOnClassLevelDefinedError)
            end
          end

        end

        describe "but not implemented" do

          it "raises Seatbelt::Errors::NoMethodError" do
            sample = SampleWithInterface.new
            expect do
              sample.factorize(6)
            end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
          end

        end

      end

    end

    describe "calling a class API method" do

      context "that exists and is implemented" do

        before(:all) do
          class RSpecSampleApiClass
            include Seatbelt::Document
            include Seatbelt::Ghost

            api_method  :find_region_by_code,
                        :scope => :class,
                        :args => [:code]
          end

          SampleWithNamespace::Sample.class_eval do
            api_method  :book_in_time,
                        :scope => :class,
                        :args => [:from, :to]
          end

          class ImplementsSampleClassMethods
            include Seatbelt::Gate
            def region_by_code(code)
              if code.eql?("de")
                "Germany"
              else
                "Great Britain"
              end
            end
            implement :region_by_code, :as => "RSpecSampleApiClass.find_region_by_code"

            def book_in_time(from, to)
              true
            end
            implement :book_in_time,
                      :as => "SampleWithNamespace::Sample.book_in_time"

          end
        end

        it "evaluates the implementation method" do
          expect(RSpecSampleApiClass.find_region_by_code("de")).to eq "Germany"
          expect(RSpecSampleApiClass.find_region_by_code("gb")).to eq "Great Britain"
          expect(SampleWithNamespace::Sample.book_in_time("20130208","20130408"))
                .to be true
        end

      end

      context "requires a block that isnt implemented" do

        before(:all) do
          Sample.class_eval do
            api_method  :record_giata_multi_codes,
                        :scope => :class,
                        :block_required => true
          end
        end

        it "raises Seatbelt::Errors::ApiMethodBlockRequiredError" do
          expect do
            Sample.record_giata_multi_codes
          end.to raise_error(Seatbelt::Errors::ApiMethodBlockRequiredError)
        end

      end

      context "that isnt defined and didn't exist" do

        it "raises Seatbelt::Errors::NoMethodError" do
          expect do
            Sample.find_hotel_next_to(:lat => 50.3, :lng => 37.5)
          end.to raise_error(Seatbelt::Errors::NoMethodError)
        end

      end

    end

    describe "tunneling to an implementation class" do

      context "tunneling enabled" do
        before(:all) do
          Sample.class_eval do
            enable_tunneling!

            api_method :call_groupings
          end
          ImplementSample.class_eval do
            include Seatbelt::Document
            attribute :groupings, Integer

            def get_groupings
              return groupings
            end
            implement :get_groupings, :as => "Sample#call_groupings"

            def tunnel_with_block(value)
              return value * yield(1)
            end
          end
        end

        it "provides #tunnel method" do
          sample = Sample.new
          expect(sample).to respond_to(:tunnel)
        end

        it "tunnels a method call to the implementation class instance" do
          sample = Sample.new
          sample.tunnel(:groupings=, 12)
          expect(sample.call_groupings).to eq 12

          result = sample.tunnel(:tunnel_with_block, 10) do |maxnum|
            3*3 - maxnum
          end
          expect(result).to eql 80
        end
      end

      context "tunneling disabled" do
        before(:all) do
          Sample.class_eval do
            disable_tunneling!
          end
        end

        it "did not provide #tunnel method" do
          expect(Sample.new).to_not respond_to(:tunnel)
          expect do
            Sample.new.tunnel(:groupings=, 12)
          end.to raise_error(Seatbelt::Errors::NoMethodError)
        end
      end

      context "tunneling not enabled" do
        before(:all) do
          class TunnelSample
            include Seatbelt::Ghost
          end
        end

        it "did not provide #tunnel method" do
          expect(TunnelSample.new).to_not respond_to(:tunnel)
        end

      end

    end

  end
end