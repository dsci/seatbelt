require 'spec_helper'

describe Seatbelt::GhostTunnel do
  let(:tunnel){ Seatbelt::GhostTunnel }

  it "is a module" do
    expect(tunnel).to be_a Module
  end

  describe "methods" do

    it "provides #enable_tunneling!" do
      expect(tunnel).to respond_to(:enable_tunneling!)
    end

    it "provides #disable_tunneling!" do
      expect(tunnel).to respond_to(:disable_tunneling!)
    end
  end

end