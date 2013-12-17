require 'spec_helper'

describe Seatbelt::Gate do
  class ImplementsA
    include Seatbelt::Gate
  end

  def stub_eigenmethods
    A.stub(:eigenmethods).and_return([])
    Vagalo::Airport.stub(:eigenmethods).and_return([])
  end

  describe "class methods" do

    it "provides #implement" do
      expect(ImplementsA).to respond_to(:implement)
    end

    it "provides #synthesize" do
      expect(ImplementsA).to respond_to(:synthesize)
    end

    it "provides #synthesize_map" do
      expect(ImplementsA).to respond_to(:synthesize_map)
    end

    describe "#implement" do

      before(:all) do
        class A; end
        module Vagalo; class Airport; end; end
        stub_eigenmethods
      end

      it "registers a logic method the the terminal" do
        expect do
          ImplementsA.class_eval do
            def fetch_flight_time; end
            implement :fetch_flight_time, :as => "A.flight_time"
          end
        end.to change{ Seatbelt::Terminal.luggage.size }.by(1)

        config = Seatbelt::Terminal.luggage.last

        expect(config).to have_key(:method)
        expect(config).to have_key(:implemented_as)
        expect(config).to have_key(:namespace)
        expect(config).to have_key(:scope)

        expect(config[:implemented_as]).to eq :flight_time
        expect(config[:namespace]).to eq "A"
        expect(config[:scope]).to eq :class
      end

      it "registers a logic method with module namespace and instance method" do
        expect do
          ImplementsA.class_eval do
            def check_flight_to(destination); end
            implement :check_flight_to, :as => "Vagalo::Airport#book_flight_to"
          end
        end.to change { Seatbelt::Terminal.luggage.size }.by(1)

        config = Seatbelt::Terminal.luggage.last

        expect(config[:namespace]).to eq "Vagalo::Airport"
        expect(config[:scope]).to eq :instance
        expect(config[:implemented_as]).to eq :book_flight_to

      end

    end

  end

  describe "instance methods" do

    it "provides #proxy_object" do
      expect(ImplementsA.new).to respond_to(:proxy_object)
    end

    describe "#proxy" do

      before(:all) do

        class ProxySample
          include Seatbelt::Document
          include Seatbelt::Ghost

          attribute :name, String

          interface :instance do
            define :bar, :args => [:name]
            define :foo
            define :codecs, :args => [:num]
          end

        end

        class ProxyImplementationSample
          include Seatbelt::Gate
          attr_accessor :airport_codes

          implementation "ProxySample", :instance do
            match 'implement_bar' => 'bar'
            match 'implement_foo' => 'foo'
            match 'implement_increase_airport_codes' => "codecs"
          end

          def implement_bar(name)
            @airport_codes = 12
            proxy.name = name
            return [proxy,self]
          end

          def implement_foo
            return [proxy,self]
          end

          def implement_increase_airport_codes(num)
            @airport_codes = num
            return self
          end

        end

      end

      it "will not be the same object for multiple API class instances" do
        first   = ProxySample.new(:name => "Foo")
        second  = ProxySample.new(:name => "Bar")

        first_proxy, first_imp   = first.bar("walter")
        second_proxy, second_imp  = second.bar("hannes")

        expect(first.codecs(99).airport_codes).to eq 99
        expect(second.codecs(200).airport_codes).to eq 200
#
        expect(first_proxy).not_to be second_proxy
        expect(first_proxy.name).to eq "walter"
        expect(second_proxy.name).to eq "hannes"
      end

    end

  end

  describe "defining implementation classes" do

    context "api methods on instance level" do

      before(:all) do
        class ApiFooSample
          include Seatbelt::Document
          include Seatbelt::Ghost

          attribute :code, Integer

          interface :instance do
            define :sample_method1
            define :sample_method2
            define :sample_method3
          end

        end

        class ImplementationApiFooSample
          include Seatbelt::Gate

          attr_accessor :codec

          implementation "ApiFooSample", :instance do
            match 'implementation_sample_method1' => 'sample_method1'
            match 'implementation_sample_method2' => 'sample_method2'
            match 'implementation_sample_method3' => 'sample_method3'
          end

          def initialize
            @codec = "mp4"
          end

          def implementation_sample_method1
            #p self.object_id
            #p proxy
            #puts caller
            #p "in implementation method"
            #p proxy.object_id
            return proxy,self, codec
          end

          def implementation_sample_method2
            #p self.object_id
            @codec = "divx"
            return proxy,self, codec
          end

          def implementation_sample_method3
            return proxy,self, codec
          end

        end
      end

      context "implementing multiple methods within the same namespace" do

        it "uses the same proxy object" do
          api = ApiFooSample.new(:code => 911)
          api2 = ApiFooSample.new(:code => 112)

          api2_proxy1,api2_object1, api_code2 = api2.sample_method1
          api1_proxy1,api1_object1, api_code1 = api.sample_method1

          sample_method1_proxy, sample_method1_object,code1 = api.sample_method1
          sample_method2_proxy, sample_method2_object,code2 = api.sample_method2
          sample_method3_proxy, sample_method3_object,code3 = api.sample_method3

          expect(sample_method1_object.object_id).to eq sample_method2_object.object_id
          expect(sample_method1_object).to eq sample_method3_object
          expect(sample_method2_object).to eq sample_method3_object

          expect(sample_method1_proxy).to eq sample_method2_proxy
          expect(sample_method1_proxy).to eq sample_method3_proxy
          expect(sample_method2_proxy).to eq sample_method3_proxy

          expect(sample_method1_proxy.code).to eq 911

          expect(code1).to eq "mp4"
          expect(code2).to eq "divx"
          expect(code3).to eq "divx"

        end

      end

      context "implementing multiple methods within several namespaces" do

        before(:all) do

          class ApiBarSample
            include Seatbelt::Ghost

            interface :instance do
              define :method1
            end

          end

          ImplementationApiFooSample.class_eval do
            implementation "ApiBarSample", :instance do
              match 'implement_with_other_namespace' => 'method1'
            end

            def implement_with_other_namespace
              return proxy, self
            end
          end

        end

        it "every method has its own proxy scope" do
          apibar  = ApiBarSample.new
          api     = ApiFooSample.new(:code => 911)

          apibar_proxy = apibar.method1.first
          api_proxy    = api.sample_method1.first

          expect(apibar_proxy).not_to be api_proxy
        end

        it "every method namespace has its own instance" do
          apibar  = ApiBarSample.new
          api     = ApiFooSample.new(:code => 911)

          apibar_object = apibar.method1[1]
          api_object    = api.sample_method1[1]

          expect(apibar_object).not_to be api_object
        end
      end

      context "methods of superclass of the implementation class" do

        before(:all) do
          class ApiInheritanceSample
            include Seatbelt::Ghost

            interface :instance do
              define :hello_world, :args => [:name]
            end
          end

          class ImplementationSuperClass

            def implementation_world(name)
              "Hello #{name}!"
            end

          end

          class ImplementationChildClass < ImplementationSuperClass
            include Seatbelt::Gate

            implementation "ApiInheritanceSample", :instance do
              match 'implementation_world' => 'hello_world', :superclass=>true
            end

          end
        end

        it "evaluates the method defined in the superclass" do
          inheritance_sample = ApiInheritanceSample.new
          expected = "Hello Max!"
          expect(inheritance_sample.hello_world("Max")).to eq expected
        end

      end
    end

    context "api methods on class level" do
      before(:all) do
        class ClassLevel
          include Seatbelt::Ghost

          interface :class do
            define :all
          end
        end
        class ImplementationClassLevel

          include Seatbelt::Gate

          implementation "ClassLevel", :class do
            match 'all' => 'all'
          end

          def self.all
            return "12"
          end
          #implement :all, :as => "ClassLevel.all"
        end
      end

      it "evaluates the class method" do
        expect(ClassLevel.all).to eq "12"
      end
    end

    context "accessing implemenation attributes" do

      context "with using proxy#tunnel" do

        before(:all) do
          class ApiB
            include Seatbelt::Document
            include Seatbelt::Ghost

            api_method :foobar
            api_method :bar
          end
          class ApiA
            include Seatbelt::Document
            include Seatbelt::Ghost

            has :b, ApiB
            api_method :my_delegating
            api_method :init_b
          end

          class ImplementationA
            include Seatbelt::Gate

            def init_b
              proxy.b = ApiB.new
            end
            implement :init_b,
                      :as => "ApiA#init_b"

            def implement_my_delegating
              proxy.tunnel("b.nice_looking")
            end
            implement :implement_my_delegating,
                      :as => "ApiA#my_delegating"
          end

          class ImplementationB
            include Seatbelt::Document
            include Seatbelt::Gate

            attribute :nice_looking, String, :default => "Black"

            def implement_foobar

            end
            implement :implement_foobar,
                      :as => "ApiB#foobar"

            def implement_bar

            end
            implement :implement_bar,
                      :as => "ApiB#bar"
          end
        end

        it "calls another implementation attribute or method" do
          api = ApiA.new
          api.init_b
          expect(api.my_delegating).to eq "Black"
        end

      end

    end
  end
end