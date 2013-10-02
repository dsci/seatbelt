require 'spec_helper'

describe Seatbelt::Proxy do
  before(:all) do
    Seatbelt::Proxy.class_eval do
      def klass
        @klass = [] unless defined?(@klass)
        @klass
      end
      private :klass
    end
  end
  describe "instance methods" do

    it "prodvides #call" do
      expect(subject).to respond_to(:call)
    end

    it "provides #tunnel" do 
      expect(subject).to respond_to(:tunnel)
    end

    describe "#call" do

      it "calls a method of its klass" do
        proxy = Seatbelt::Proxy.new
        expect(proxy.call(:empty?)).to be true
        expect do
          proxy.call(:push, 1)
        end.to change{ proxy.send(:klass).size }.by(1)
        expect do
          proxy.push(1)
        end.to change{ proxy.send(:klass).size }.by(1)
      end

    end

    describe "#tunnel" do 
      let(:klass){ double(:region) }
      let(:proxy){ Seatbelt::Proxy.new }
      let(:implementation_object){ double("implementation") }
      def define_doubles
        implementation_object.stub(:my_implementation_attribute).
                              and_return("Black")
        eigenmethod = double("Seatbelt::Eigenmethod")
        eigenmethod.stub(:callee).and_return(implementation_object)
        implementation_object.stub(:eigenmethods).and_return([eigenmethod])
        klass.stub(:hasable).and_return(implementation_object)
      end

      before do 
        define_doubles
        proxy.stub(:object).and_return(klass)
      end

      it "delegates a method chain call to the underlying callee object" do 
        expect(proxy.tunnel("hasable.my_implementation_attribute")).to eq "Black"
      end

      context "calling a not existing object" do 

        it "raises a Seatbelt::Errors::ObjectDoesNotExistError" do 
          expect do 
            proxy.tunnel("likeable.an_attribute")
          end.to raise_error(Seatbelt::Errors::ObjectDoesNotExistError, 
                             "The object you called does not exist.")
        end
      end

      context "calling with an unchained argument" do 

        it "generates a warning" do 
          implementation_object.stub(:hasable).and_return([])
          proxy.should_receive(:warn).with("You called a single object. Use #call instead.")
          proxy.tunnel("hasable")
        end

      end

    end

  end

  describe "calling not allowable methods on proxy object" do

    it "raises a NoMethodError" do
      proxy = Seatbelt::Proxy.new
      expect{ proxy.klass }.to raise_error(NoMethodError)
      expect(proxy.object).to be_instance_of Array

      Seatbelt::Proxy.class_eval do
        def klass
          @klass = Array unless defined?(@klass)
          @klass  
        end
        private :klass
      end

      proxy = Seatbelt::Proxy.new
      expect{ proxy.klass }.to raise_error(NoMethodError)
      expect(proxy.object).to be Array
      expect do
        proxy.try_convert([1])
      end.to_not raise_error
    end
  end

end