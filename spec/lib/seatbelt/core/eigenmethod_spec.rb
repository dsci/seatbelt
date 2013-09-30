require 'spec_helper'

describe Seatbelt::Eigenmethod do

  it "provides #scope_level" do
    expect(subject).to respond_to(:scope_level)
    expect(subject).to respond_to(:scope_level=)
  end

  it "provides #receiver" do
    expect(subject).to respond_to(:receiver)
    expect(subject).to respond_to(:receiver=)
  end

  it "provides #namespace" do
    expect(subject).to respond_to(:namespace)
    expect(subject).to respond_to(:namespace=)
  end

  it "provides #implemented_as" do
    expect(subject).to respond_to(:implemented_as)
    expect(subject).to respond_to(:implemented_as=)
  end

  it "provides #method" do
    expect(subject).to respond_to(:method=)
  end

  it "provides #method_implementation_type" do
    expect(subject).to respond_to(:method_implementation_type=)
    expect(subject).to respond_to(:method_implementation_type)
  end

  it "provides #call" do
    expect(subject).to respond_to(:call)
  end

  it "provides #instance_level?" do
    expect(subject).to respond_to(:instance_level?)
  end

  it "provides #class_level?" do
    expect(subject).to respond_to(:class_level?)
  end

  describe "#call" do
    let(:proxy){ Seatbelt::Eigenmethod.new }
    context "on instance level" do

      before do
        class Sample
          def foo(a,b)
            a*b
          end
        end
        proxy.method          = Sample.instance_method(:foo)
        proxy.receiver        = Sample
        proxy.scope_level     = :instance
        proxy.implemented_as  = :superfoo
        proxy.instance_variable_set(:@callee, Sample.new)
      end

      it "calls the implemented method" do
        expect(proxy.call(2,4)).to eq 8
      end

    end

    context "on class level" do

      before do
        class NextSample
          def self.count
            return 12
          end
        end
        proxy.method          = :count
        proxy.receiver        = NextSample
        proxy.scope_level     = :class
        proxy.implemented_as  = :superfoo
        proxy.method_implementation_type = :class
      end

      it "calls the implemented method" do
        expect(proxy.call).to eq 12
      end

      context "calling instance method on class level" do
        before do
          class Sample
          end
        end
      end

    end
  end

end