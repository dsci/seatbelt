require 'spec_helper'

describe Seatbelt::Models::TravelRequest do

  def klass
    Seatbelt::Models::TravelRequest
  end


  subject { klass.new }

  it_behaves_like "ApiClass"


  describe "#properties" do
    
    it "returns a Hash" do
      expect(subject.properties).to be_a Hash
    end

    it "requests accessible properties" do
      klass::ACCESSIBLE_PROPERTIES.each do |prop|
        expect(subject).to receive(prop)
      end
      subject.properties
    end

    it "returns as many key-value-apirs as properties accessible" do
      cnt = klass::ACCESSIBLE_PROPERTIES.count
      expect(subject.properties.keys.count).to eq cnt
    end

  end

  describe "#properties=" do

    let(:random_prop) { klass::ACCESSIBLE_PROPERTIES.sample }

    it "sets the value of an acessible property" do
      prop = random_prop
      subject.properties = { prop => "something" }
      expect(subject.send(prop)).to eq "something"
    end

    
    it "param nil sets all properties to nil" do
      prop = random_prop      
      subject.properties = { prop => "something else" }
      subject.properties = nil
      expect(subject.send(prop)).to be_nil
    end

  end

end