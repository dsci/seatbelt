require 'spec_helper'

describe Seatbelt::Proxy do

  describe "instance methods" do

    it "prodvides #call" do
      expect(subject).to respond_to(:call)
    end

    describe "#call" do
      before(:all) do
        Seatbelt::Proxy.class_eval do
          def klass
            @klass = [] unless defined?(@klass)
            @klass
          end
          private :klass
        end
      end

      it "calls a method of its klass" do
        proxy = Seatbelt::Proxy.new
        expect(proxy.call(:empty?)).to be true
        expect do
          proxy.call(:push, 1)
        end.to change{ proxy.send(:klass).size }.by(1)
      end

    end
  end

end