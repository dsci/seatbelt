require 'spec_helper'

describe Seatbelt::Models::TravelRequest do

  def klass
    Seatbelt::Models::TravelRequest
  end

  it_behaves_like "ApiClass"


  %w( language ).each do |attr_name|
  
    it "responds to :#{attr_name}" do 
      expect(subject).to respond_to attr_name
    end

  end


  describe "#properties" do
    
    it "returns a Hash" do
      expect(subject.properties).to be_a Hash
    end

    it "requests accessible properties" do
      subject.properties.each do |prop_key, prop_value|
        expect(subject).to receive(prop_key)
      end
      subject.properties
    end

    it "returns as many key-value-pairs as properties accessible" do
      cnt = subject.properties.count
      expect(subject.properties.keys.count).to eq cnt
    end

  end

  describe "#properties=" do

    let(:random_prop) { subject.properties.keys.sample }

    it "sets the value of an acessible property" do
      prop = random_prop
      subject.properties = { prop => "something" }
      expect(subject.send(prop)).to eq "something"
    end
    
  end

end