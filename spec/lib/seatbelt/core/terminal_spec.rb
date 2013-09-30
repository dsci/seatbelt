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
          stub_eigenmethods(Hash)
          expect do
            Seatbelt::Terminal.call(:my_method, Hash, 1,2)
          end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
        end

      end

      context "method to call is not implemented" do

        module Seatbelt
          class Array < ::Array
            include Seatbelt::Gate
          end
        end

        before do
          proxy                 = Seatbelt::Eigenmethod.new
          proxy.method          = Array.instance_method(:push)
          proxy.implemented_as  = :add_item
          proxy.scope           = :class
          proxy.namespace       = "Seatbelt::Array"
          proxy.receiver        = Array

          Seatbelt::Terminal.luggage << proxy

          proxy                 = Seatbelt::Eigenmethod.new
          proxy.method          = Array.instance_method(:push)
          proxy.implemented_as  = :my_method
          proxy.scope           = :instance
          proxy.namespace       = "Seatbelt::Array"
          proxy.receiver        = Array

          Seatbelt::Terminal.luggage << proxy
        end

        it "raises Seatbelt::MethodNotImplementedError" do
          stub_eigenmethods(Seatbelt::Array)
          expect do
            Seatbelt::Terminal.call(:my_method, Seatbelt::Array, 1,2)
          end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
        end

        context "the same method name but different namespace" do

          it "raises Seatbelt::MethodNotImplementedError" do
            hsh = {}
            stub_eigenmethods(hsh)
            expect do
              Seatbelt::Terminal.call(:my_method, hsh, 1,2)
            end.to raise_error(Seatbelt::Errors::MethodNotImplementedError)
          end

        end

      end

      context "method to call is implemented" do

        before(:all) do
          class ASample
            include Seatbelt::Ghost
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
                p proxy
                factor1 * factor2 - proxy.call(:klass_method)
              end
              implement :acts_as_class_method, :as => "ASample.c_method"

              def return_proxy
                return proxy.object
              end
              implement :return_proxy, :as => "ASample#chain"

              def self.klass_method
                return 2 + proxy.call(:klass_method)
              end
              implement :klass_method, :as => "ASample.klass_method",
                        :type => :class
            end
          end
        end

        context "and it's an instance method" do
          it "delegates to the implemented method" do
            packages = Seatbelt::Terminal.for_scope_and_namespace(:instance,
                                                                  "ASample")
            asample = ASample.new
            packages.each do |package|
              Seatbelt::EigenmethodProxy.set(Seatbelt::Proxy.new,
                                              { :eigenmethod => package,
                                                :object      => asample,
                                                :receiver    => package.receiver,
                                              })
            end
            expect(Seatbelt::Terminal.call(:my_method, ASample.new ,2)).to eq 6

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
            package = Seatbelt::Terminal.luggage.select do |pack|
              pack.implemented_as.eql?(:c_method)
            end.first
            options = {
              :eigenmethod => package,
              :receiver    => ASample.new,
              :add_to      => true,
            }
            #Seatbelt::EigenmethodProxy.set(Seatbelt::Proxy.new, options)
            ASample.class_eval do
              api_method :c_method, :scope => :class
            end
            ASample.c_method(2,3)
            #expect(Seatbelt::Terminal.call(:c_method, ASample,2,3)).to eq 5
            #expect(Seatbelt::Terminal.call(:klass_method, ASample)).to eq 3
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