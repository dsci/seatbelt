require 'spec_helper'

describe ::Seatbelt::Models::Offer do
  
  subject { Seatbelt::Models::Offer.new }

  %w( departure_date
      days
      operator
      hotel_gid
      hotel_goc
      hotel_dlc
      hotel_fid
      hotel_ref
      hotel_cat
      hotel_name
      city_gid
      city_name
      region_name
      destination_name
      departure_airport_code
      price
      on_price
      bf_price
      hb_price
      fb_price
      ai_price
      entire_price
      on_entire_price
      bf_entire_price
      hb_entire_price
      fb_entire_price
      ai_entire_price
      distance_to_beach
      water_temperature
      air_temperature
      hotel_hcid
      hotel_reviews
      hotel_rating
      hotel_recommendation_rate ).each do |attr_name|
  
    it "responds to :#{attr_name}" do 
      expect(subject).to respond_to attr_name
    end

  end

  describe "#lowest_price" do

    it "returns the lowest price of available prices" do
      subject.attributes = { on_price: 100, bf_price: 120, ai_price: 180 }
      expect(subject.lowest_price).to eq 100
    end
  
  end

  describe "#lowest_entire_price" do

    it "returns the lowest entire price of available entire prices" do
      subject.attributes = { bf_entire_price: 240, ai_entire_price: 310 }
      expect(subject.lowest_entire_price).to eq 240
    end
  
  end

end
