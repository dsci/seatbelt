require 'spec_helper'

describe Seatbelt::Terminal do

  describe "class methods" do

    it "provides #luggage=" do
      expect(Seatbelt::Terminal).to respond_to(:luggage=)
    end

    it "provides #luggage" do
      expect(Seatbelt::Terminal).to respond_to(:luggage)
    end

    it "provides #call" do
      expect(Seatbelt::Terminal).to respond_to(:call)
    end

    describe "#call" do

      context "lugagge store is empty" do

        it "calling a method raises Seatbelt::MethodNotImplementedError" do
          expect do
            Seatbelt::Terminal.call(:my_method, Hash, 1,2)
          end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
        end

      end

      context "method to call is not implemented" do

        module Seatbelt
          class Array < ::Array
          end
        end

        before do
          config = {
            :method         => Array.instance_method(:push),
            :implemented_as => :add_item,
            :namespace      => "Seatbelt::Array",
            :scope          => :class
          }
          Seatbelt::Terminal.luggage << config

          config = {
            :method         => Array.instance_method(:push),
            :implemented_as => :my_method,
            :namespace      => "Seatbelt::Array",
            :scope          => :instance
          }

          Seatbelt::Terminal.luggage << config
        end

        it "raises Seatbelt::MethodNotImplementedError" do
          expect do
            Seatbelt::Terminal.call(:my_method, Seatbelt::Array, 1,2)
          end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
        end

        context "the same method name but different namespace" do

          it "raises Seatbelt::MethodNotImplementedError" do
            expect do
              Seatbelt::Terminal.call(:my_method, {}, 1,2)
            end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
          end

        end

      end

      context "method to call is implemented" do

        before(:all) do
          class ASample
            def abs_of_number(number)
              number.abs
            end

            def self.klass_method
              1
            end
          end

          module Seatbelt
            class ImplementA
              include Gate

              def method_to_call(num)
                2+num+proxy.call(:abs_of_number, -2)
              end
              implement :method_to_call, :as => "ASample#my_method"

              def acts_as_class_method(factor1, factor2)
                factor1 * factor2 - proxy.call(:klass_method)
              end
              implement :acts_as_class_method, :as => "ASample.c_method"

              def return_proxy
                return proxy.object
              end
              implement :return_proxy, :as => "ASample#chain"
            end
          end
        end

        context "and it's an instance method" do
          it "delegates to the implemented method" do
            expect(Seatbelt::Terminal.call(:my_method, ASample.new,2)).to eq 6

            expect(Seatbelt::Terminal.call(:chain, ASample.new)).to \
                  respond_to(:abs_of_number)
          end

          it "raises an ArgumentError if too few arguments passed through" do
            expect do
              Seatbelt::Terminal.call(:my_method, ASample.new)
            end.to raise_error(ArgumentError)
          end

        end

        context "and it's a class method" do
          it "delegates to the implemented method" do
            expect(Seatbelt::Terminal.call(:c_method, ASample,2,3)).to eq 5
          end

          it "raises an ArgumentError if too few arguments passed through" do
            expect do
              Seatbelt::Terminal.call(:c_method, ASample,3)
            end.to raise_error(ArgumentError)

          end
        end

      end
    end

  end

end