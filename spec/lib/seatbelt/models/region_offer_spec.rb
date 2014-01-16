require 'spec_helper'

describe ::Seatbelt::Models::RegionOffer do
  
  %w( region_name
      region_code
      lowest_price
      lowest_entire_price
      airport_codes ).each do |attr_name|
  
    it "responds to :#{attr_name}" do 
      expect(subject).to respond_to attr_name
    end

  end

end
