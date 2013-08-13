require 'spec_helper'

describe Seatbelt::GateConfig do

  describe "class methods" do

    it "provides #method_directive_instance=" do
      expect(Seatbelt::GateConfig).to respond_to(:method_directive_instance=)
    end

    it "provides #method_directive_instance" do
      expect(Seatbelt::GateConfig).to respond_to(:method_directive_instance)
    end

    it "provides #method_directive_class" do
      expect(Seatbelt::GateConfig).to respond_to(:method_directive_class)
    end

    it "provides #method_directive_class=" do
      expect(Seatbelt::GateConfig).to respond_to(:method_directive_class=)
    end

    it "provides #method_directives" do
      expect(Seatbelt::GateConfig).to respond_to(:method_directives)
    end

    describe "#method_directives" do

      before(:all) do
        @directives = Seatbelt::GateConfig.method_directives
      end

      it "has a :class key and a default value ." do
        expect(@directives).to have_key(:class)
        expect(@directives[:class]).to eq "."
      end

      it "has a :instance key and a default value #" do
        expect(@directives).to have_key(:instance)
        expect(@directives[:instance]).to eq "#"
      end

    end

    describe "#method_directive_instance" do

      context "default value" do

        it "is #" do
          expect(Seatbelt::GateConfig.method_directive_instance).to eq "#"
        end

      end

      context "custom value" do

        it "if | set it is |" do
          Seatbelt::GateConfig.method_directive_instance="|"
          expect(Seatbelt::GateConfig.method_directive_instance).to eq "|"
        end

        it "if :: is set it raises a Seatbelt::Errors::DirectiveNotAllowedError" do
          expect do
            Seatbelt::GateConfig.method_directive_instance="::"
          end.to raise_error(Seatbelt::Errors::DirectiveNotAllowedError)
        end

      end

    end

    describe "#method_directive_class" do

      context "default value" do

        it "is ." do
          expect(Seatbelt::GateConfig.method_directive_class).to eq "."
        end

        it "if / set it is /" do
          Seatbelt::GateConfig.method_directive_class="/"
          expect(Seatbelt::GateConfig.method_directive_class).to eq "/"
        end

        it "if :: is set it raises a Seatbelt::Errors::DirectiveNotAllowedError" do
          expect do
            Seatbelt::GateConfig.method_directive_class="::"
          end.to raise_error(Seatbelt::Errors::DirectiveNotAllowedError)
        end

      end

    end


  end

end