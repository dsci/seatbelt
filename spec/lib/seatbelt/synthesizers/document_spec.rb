require 'spec_helper'

describe Seatbelt::Synthesizers::Document do
  describe "#synthesize" do

    before(:all) do
      class ApiDocumentSynthesize
        include Seatbelt::Document
        include Seatbelt::Ghost

        attribute :name,  String
        attribute :age,   Integer

        api_method :lolspeak_my_name
      end

      class ImplementationApiDocumentSynthesize
        include Seatbelt::Document
        include Seatbelt::Gate

        #field :name, :type => String
        attribute :name, String

        synthesize :from => "ApiDocumentSynthesize"

        def implement_lolspeak_my_name
          return self
        end
        implement :implement_lolspeak_my_name,
                  :as => "ApiDocumentSynthesize#lolspeak_my_name"
      end
    end

    it "synchrones the implementation object with the proxy object" do
      api = ApiDocumentSynthesize.new(:name => "Hendrik")

      impl_name = api.lolspeak_my_name

      expect(impl_name.name).to eq api.name
      api.name="Jan"
      expect(impl_name.name).to eq api.name
      impl_name.name = "Gerno"
      expect(api.name).to eq impl_name.name
    end

    end
end