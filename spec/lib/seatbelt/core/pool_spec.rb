require 'spec_helper'

describe Seatbelt::Pool::Api do
  let(:pool){ Seatbelt::Pool::Api }

  it "is a module" do
    expect(pool).to be_a Module
  end

  describe "methods" do

    it "provides #api_method" do
      expect(pool).to respond_to(:api_method)
    end

    it "provides #lookup_tbl as class attribute accessor" do
      expect(pool).to respond_to(:lookup_tbl)
    end

    describe '#lookup_tbl' do

      it "is empty at the beginning" do
        expect(pool.lookup_tbl).to be_empty
      end

      context "adding something to the lookup table" do

        it "increases the lookup tables size" do
          expect{ pool.lookup_tbl << 1 }.to change{ pool.lookup_tbl.size }.by(1)
        end

      end

      context "removing something from the lookup table" do

        it "decreases the lookup table size" do
          expect do
            pool.lookup_tbl.pop
            pool.lookup_tbl
          end.to change{ pool.lookup_tbl.size }.by(-1)
        end

      end

    end

    describe "#api_method" do

      context "its signature" do

        after do
          pool.instance_variable_set(:@lookup_tbl, Seatbelt::LookupTable.new)
        end

        it "requires at least a method name" do
          expect do
            pool.api_method
          end.to raise_error(Seatbelt::Errors::ArgumentsMissmatchError)

          expect do
            pool.api_method :scope          =>  :class,
                            :block_required =>  true
          end.to raise_error(Seatbelt::Errors::MissingMetaMethodName)

        end

      end

      context "adding meta-method definitions to the pools lookup_tbl" do

        context "with just a meta-method name" do

          it "uses default attributes" do
            expect do
              pool.api_method :sample_method
              pool.lookup_tbl
            end.to change{ pool.lookup_tbl.size }.by(1)
            lookup_tbl_entry = pool.lookup_tbl.first

            expect(lookup_tbl_entry).to be_instance_of(Hash)
            expect(lookup_tbl_entry.keys.first).to eq :sample_method
            expect(lookup_tbl_entry[:sample_method]).to_not be_empty

            meta_method_options = lookup_tbl_entry[:sample_method]
            expect(meta_method_options).to have_key(:scope)
            expect(meta_method_options).to have_key(:block_required)
            expect(meta_method_options[:scope]).to eq :instance
            expect(meta_method_options[:block_required]).to eq false
          end

        end

        context "with a meta-method name and a scope" do

          it "uses the scope and default attributes" do
            expect do
              pool.api_method :find_scope,
                              :scope => :class
            end.to change{ pool.lookup_tbl.size }.by(1)
            expect(pool.lookup_tbl.size).to eq 2
            lookup_tbl_entry = pool.lookup_tbl.last
            expect(lookup_tbl_entry).to be_instance_of(Hash)
            expect(lookup_tbl_entry.keys.first).to eq :find_scope
            expect(lookup_tbl_entry[:find_scope]).to_not be_empty

            meta_method_options = lookup_tbl_entry[:find_scope]
            expect(meta_method_options).to have_key(:scope)
            expect(meta_method_options).to have_key(:block_required)
            expect(meta_method_options[:scope]).to eq :class
            expect(meta_method_options[:block_required]).to eq false
          end

        end

        context "with a meta-method name, a scope and block required" do

          it "uses the passed arguments" do
            expect do
              pool.api_method :block_box,
                              :scope => :class,
                              :block_required => true
            end.to change{ pool.lookup_tbl.size }.by(1)
            expect(pool.lookup_tbl.size).to eq 3
            lookup_tbl_entry = pool.lookup_tbl.last
            expect(lookup_tbl_entry).to be_instance_of(Hash)
            expect(lookup_tbl_entry.keys.first).to eq :block_box
            expect(lookup_tbl_entry[:block_box]).to_not be_empty

            meta_method_options = lookup_tbl_entry[:block_box]
            expect(meta_method_options).to have_key(:scope)
            expect(meta_method_options).to have_key(:block_required)
            expect(meta_method_options[:scope]).to eq :class
            expect(meta_method_options[:block_required]).to eq true
          end

        end

        context "with a meta-method name and block_required" do

          it "uses the block_required and default attributes" do
            expect do
              pool.api_method :parameter_box,
                              :block_required => true
            end.to change{ pool.lookup_tbl.size }.by(1)
            expect(pool.lookup_tbl.size).to eq 4
            lookup_tbl_entry = pool.lookup_tbl.last
            expect(lookup_tbl_entry).to be_instance_of(Hash)
            expect(lookup_tbl_entry.keys.first).to eq :parameter_box
            expect(lookup_tbl_entry[:parameter_box]).to_not be_empty

            meta_method_options = lookup_tbl_entry[:parameter_box]
            expect(meta_method_options).to have_key(:scope)
            expect(meta_method_options).to have_key(:block_required)
            expect(meta_method_options[:scope]).to eq :instance
            expect(meta_method_options[:block_required]).to eq true
          end

        end

        context "with a duplicated meta-method name" do

          it "raises a Seatbelt::MetaMethodDuplicateError error" do
            expect do
              pool.api_method :block_box
            end.to raise_error Seatbelt::Errors::MetaMethodDuplicateError
          end
        end

        describe "#arity" do

          context "specifying arguments" do

            describe "without argument list" do

              it "is an unsigned number of arguments passed to #api_method" do
                pool.api_method :method_with_attrs, :args => [:a, :b, :c]
                expect(pool.lookup_tbl.last[:method_with_attrs][:arity]).to eq 3
              end

              describe "and default values" do

                it "is a signed number of arguments passed to #api_method" do
                  pool.api_method :method_with_defaults, :args => [:a, :b,"k=1"]
                  method = pool.lookup_tbl.last[:method_with_defaults]
                  expect(method[:arity]).to eq -3
                end

              end

              describe "and block" do

                it "ignores the block argument" do
                  pool.api_method :method_with_block, :args => [:a, :b, "&c"]
                  method = pool.lookup_tbl.last[:method_with_block]
                  expect(method[:arity]).to eq 2
                end

                describe "and default values" do

                  it "is a signed number of arguments passed to #api_method" do
                    args = [:a,"k=1", "&block"]
                    pool.api_method :method_block_defaults, :args => args
                    method = pool.lookup_tbl.last[:method_block_defaults]
                    expect(method[:arity]).to eq -2
                  end

              end

              end

            end

            describe "with arguments list" do

              it "is a signed number of arguments passed to #api_method" do
                pool.api_method :method_wth_args_list,
                                :args => ["a", "b", "c", "*f"]
                method = pool.lookup_tbl.last[:method_wth_args_list][:arity]
                expect(method).to eq -4
              end

              describe "and default values" do

                it "is a signed number of arguments passed to #api_method" do
                  pool.api_method :method_args_a_defs,
                                  :args => ["a", "b", "c=12","*f"]
                  method = pool.lookup_tbl.last[:method_args_a_defs]
                  expect(method[:arity]).to eq -3
                end

              end

              describe "and block" do
                it "ignores the block argument" do
                  pool.api_method :method_args_l_block, :args => [:a, "*f", "&c"]
                  method = pool.lookup_tbl.last[:method_args_l_block]
                  expect(method[:arity]).to eq -2
                end

                describe "and default values" do
                  it "is a signed number of arguments passed to #api_method" do
                    pool.api_method :method_args_a_defs_block,
                                    :args => ["a", "b", "c=12","*f" , "&block"]
                    method = pool.lookup_tbl.last[:method_args_a_defs_block]
                    expect(method[:arity]).to eq -3
                  end
                end

              end

            end

          end

          context "omitting arguments" do
            it "is 0" do
              pool.api_method :my_method
              expect(pool.lookup_tbl.last[:my_method][:arity]).to equal 0
            end
          end

        end

      end

    end

  end

end