require 'spec_helper'

describe Seatbelt::Collections::Collection do

  describe "class_methods" do

    it "provides #model_class" do
      expect(Seatbelt::Collections::Collection).to respond_to(:model_class)
    end

  end

end

describe Seatbelt::Collections::FlightCollection do

  it_behaves_like "CollectionChild", Seatbelt::Collections::FlightCollection

end

describe Seatbelt::Collections::RegionCollection do

  it_behaves_like "CollectionChild", Seatbelt::Collections::RegionCollection

end

describe Seatbelt::Collections::OfferCollection do

  it_behaves_like "CollectionChild", Seatbelt::Collections::OfferCollection

end

describe Seatbelt::Collections::AirportCollection do

  it_behaves_like "CollectionChild", Seatbelt::Collections::AirportCollection

end

describe Seatbelt::Collections::CountryCollection do

  it_behaves_like "CollectionChild", Seatbelt::Collections::CountryCollection

end

describe Seatbelt::Collections::HotelCollection do

  it_behaves_like "CollectionChild", Seatbelt::Collections::HotelCollection

end