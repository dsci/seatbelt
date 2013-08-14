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
    end

    describe "calling an instance API method" do

      before(:all) do
        Seatbelt.configure_gate do |config|
          config.method_directive_class     = "."
          config.method_directive_instance  = "#"
        end

        Sample.class_eval do
          api_method :sum_numbers
        end

        class ImplementSample
          include Seatbelt::Gate

          def sum_numbers_implementation(a,b)
            a+b
          end
          implement :sum_numbers_implementation, :as => "Sample#sum_numbers"

        end

        SampleWithNamespace::Sample.class_eval do
          api_method :seat_count
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

    end

    describe "calling a class API method" do

      context "that exists and is implemented" do

        before(:all) do
          Sample.class_eval do
            api_method  :find_region_by_code,
                        :scope => :class
          end

          SampleWithNamespace::Sample.class_eval do
            api_method  :book_in_time,
                        :scope => :class
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
            implement :region_by_code, :as => "Sample.find_region_by_code"

            def book_in_time(from, to)
              true
            end
            implement :book_in_time,
                      :as => "SampleWithNamespace::Sample.book_in_time"

          end
        end

        it "evaluates the implementation method" do
          expect(Sample.find_region_by_code("de")).to eq "Germany"
          expect(Sample.find_region_by_code("gb")).to eq "Great Britain"
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

  end
end