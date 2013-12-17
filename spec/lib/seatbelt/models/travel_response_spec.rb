require 'spec_helper'

describe ::Seatbelt::Models::TravelResponse do
  
  subject { Seatbelt::Models::TravelResponse.new }

  describe "attributes" do

    %w{ docs
        total
        from
        to }.each do |prop|
  
      it "includes ##{prop}" do
        expect(subject).to respond_to(prop.to_sym)
      end
    end

  end

  describe "#total" do

    before{ subject.total = "1500" }

    it "is an Integer" do
      expect(subject.total).to be_an Integer
    end

  end

  describe "#from" do

    before{ subject.from = "1500" }

    it "is an Integer" do
      expect(subject.from).to be_an Integer
    end

  end

  describe "#to" do

    before{ subject.to = "1500" }

    it "is an Integer" do
      expect(subject.to).to be_an Integer
    end

  end

end
