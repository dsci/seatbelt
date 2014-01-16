require 'spec_helper'

describe ::Seatbelt::Models::RegionResponse do
  
  describe "attributes" do

    it "includes #docs" do
      expect(subject).to respond_to(:docs)
    end

  end

end
