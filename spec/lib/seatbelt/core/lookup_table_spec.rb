require 'spec_helper'

describe Seatbelt::LookupTable do
  let(:table){ Seatbelt::LookupTable.new }

  it{ should be_a_kind_of(Array)}

  describe "instance methods" do

    it "provides #add_method" do
      expect(subject).to respond_to(:add_method)
    end

    it "provides #set" do
      expect(subject).to respond_to(:set)
    end

    it "provides #get" do
      expect(subject).to respond_to(:get)
    end

    it "provides #unset" do
      expect(subject).to respond_to(:unset)
    end

    it "provides #remove_method" do
      expect(subject).to respond_to(:remove_method)
    end

    it "provides #find_method" do
      expect(subject).to respond_to(:find_method)
    end

    it "provides #has?" do
      expect(subject).to respond_to(:has?)
    end

    describe "#has?" do

      before(:all) do
        @table = Seatbelt::LookupTable.new
        @options = {
          :has_method => {
            :scope          => :class,
            :block_required => false
          }
        }
        @table.set(@options)
      end

      after(:all){ @table.clear }

      describe "with the method name as argument" do

        context "and a method with this name exists" do

          it "returns true" do
            expect(@table.has?(:has_method, scope: :class)).to be true
          end

        end

        context "and no method wthis name exists" do

          it "returns false" do
            expect(@table.has?(:method_I_havent)).to be false
          end

        end
      end

      describe "with method configuration as argument" do

        context "and a method with this configuration exists" do

          it "returns true" do
            options = {
              :has_method => {
                :scope          => :class,
                :block_required => false,
              }
            }
            expect(@table.has?(options)).to be true
          end
        end

        context "and no method with this configuration exists" do

          it "returns false" do
            options = {
              :has_method => {
                :scope          => :class,
                :block_required => true,
              }
            }
            expect(@table.has?(options)).to be false
          end
        end
      end

    end

    describe "#find_method" do
      before do
        @option_class = {
          :foobar => {
            :scope          => :class,
            :block_required => false
          }
        }

        @option_instance = {
          :foobar => {
            :scope          => :instance,
            :block_required => true
          }
        }

        table.set(@option_class)
        table.set(@option_instance)
      end

      it "finds instance method by default" do
        expect(table.find_method(:foobar, scope: :instance)).to eq @option_instance
      end

    end

    describe "#get" do

      describe "lookup has a method to get " do

        before(:all) do
          @table = Seatbelt::LookupTable.new
          @options = {
              :get_flights => {
                :scope          => :class,
                :block_required => false,
              }
            }
          @table.set(@options)
        end

        context "by method name" do

          it "returns the method configuration" do
            fetched_method = @table.get(:get_flights, scope: :class)
            expect(fetched_method).to eq @options
          end

        end

        context "by method configuration" do

          it "returns the method configuration" do
            fetched_method = @table.get(@options)
            expect(fetched_method).to eq @options
          end

        end

      end

      describe "lookup has no method to get " do
        before(:all){ @table = Seatbelt::LookupTable.new }

        context "by method name" do

          it "returns nil" do
            expect(@table.get(:my_method)).to be nil
          end

        end

        context "by method configuration" do

          it "returns nil" do
            expect(@table.get({:method => {:scope => :class}})).to be nil
          end
        end
      end

    end

    describe "#remove_method" do
      context "lookup table did not contain any methods" do

        it "nothing happens" do
          expect do
            table.remove_method(:my_method)
          end.to_not change{ table.size }
          expect(table).to be_empty
        end

      end

      describe "lookup table contains methods" do
        context "and method to remove is included" do

          let(:method_options) do
            {
              :my_method => {
                :scope          => :class,
                :block_required => false
              }
            }
          end

          before  { table.set(method_options) }
          after   { table.clear }

          it "removes the method and returns the removed configuration" do
            config = {}
            expect do
              config = table.remove_method(:my_method, scope: :class)
            end.to change{ table.size }.by(-1)
            expect(config).to be_a_kind_of(Hash)
            expect(config).to eq method_options
          end

        end

        context "and method to remove is not included" do

          it "nothing happens" do
            expect do
              table.remove_method(:any_other_method)
            end.to change{ table.size }.by(0)
          end
        end
      end
    end
  end
end
