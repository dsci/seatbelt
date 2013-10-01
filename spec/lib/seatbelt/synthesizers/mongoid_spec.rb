require 'spec_helper'

describe Seatbelt::Synthesizers::Mongoid do
  describe "#synthesize" do

    before(:all) do
      class ApiMongoidSynthesize
        include Seatbelt::Document
        include Seatbelt::Ghost

        attribute :name, String
        attribute :age,  Integer

        api_method :lolspeak_my_name
      end

      class ApiMongoidSynthesize2
        include Seatbelt::Document
        include Seatbelt::Ghost

        attribute :name,     String
        attribute :lastname, String

        api_method :lolspeak_lastname
        api_method :change_my_name
      end

      class ImplementationApiMongoidSynthesize
        include ::Mongoid::Document
        include Seatbelt::Gate

        field :name,      :type => String
        field :age,       :type => String
        field :lastname,  :type => String

        synthesize  :from     => "ApiMongoidSynthesize",
                    :adapter  => "Seatbelt::Synthesizers::Mongoid"

        def implement_lolspeak_my_name
          return self
        end
        implement :implement_lolspeak_my_name,
                  :as => "ApiMongoidSynthesize#lolspeak_my_name"

        def implement_lolspeak_lastname
          return self
        end
        implement :implement_lolspeak_lastname,
                  :as => "ApiMongoidSynthesize2#lolspeak_lastname"

        def implement_change_my_name(name_value)
          @proxy.name = name_value
          return self
        end
        implement :implement_change_my_name,
                  :as => "ApiMongoidSynthesize2#change_my_name"
      end
    end

    it "synchrones the implementation object with the proxy object" do
      api = ApiMongoidSynthesize.new(:name => "Hendrik")

      impl_name = api.lolspeak_my_name

      expect(impl_name.name).to eq api.name
      api.name="Jan"
      expect(impl_name.name).to eq api.name
      impl_name.name = "Gerno"
      expect(api.name).to eq impl_name.name

      api2 = ApiMongoidSynthesize.new(:name => "Jon")

      impl2_name = api2.lolspeak_my_name
      expect(impl2_name.name).to eq api2.name
    end

    describe "different attributes than API class" do
      before(:all) do
        class ApiMongoid
          include Seatbelt::Document
          include Seatbelt::Ghost

          attribute :name, String
          attribute :age,  Integer

          api_method :my_name
        end
        class ImplementationApiMongoidSynthesizeDifferentAttrs
          include ::Mongoid::Document
          include Seatbelt::Gate

          field :prx_identifier,  :type => String
          field :n_age,           :type => Integer

          synthesize  :from     => "ApiMongoid",
                      :adapter  => "Seatbelt::Synthesizers::Mongoid"

          synthesize_map :name => :prx_identifier,:age  => :n_age

          def implement_speak_my_name
            return self
          end
          implement :implement_speak_my_name,
                    :as => "ApiMongoid#my_name"
        end
      end
      it "synchrones the implementation object with the proxy object" do
        api = ApiMongoid.new(:name => "John")

        impl_name = api.my_name
        expect(impl_name.prx_identifier).to eq api.name

        api.name="Jan"
        expect(impl_name.prx_identifier).to eq api.name
        impl_name.prx_identifier = "Gerno"
        expect(api.name).to eq impl_name.prx_identifier

        api.age = 29
        expect(impl_name.n_age).to eq api.age

        impl_name.n_age = 44
        expect(api.age).to eq impl_name.n_age

        api2 = ApiMongoid.new(:name => "George",:age => 65)

        impl2_name = api2.my_name
        expect(impl2_name.prx_identifier).to eq api2.name
        expect(impl2_name.n_age).to eq api2.age

      end
    end

  end
end