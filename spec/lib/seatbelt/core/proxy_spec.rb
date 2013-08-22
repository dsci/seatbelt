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