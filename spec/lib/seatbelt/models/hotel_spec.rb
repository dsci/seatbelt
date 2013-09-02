require 'spec_helper'

describe Seatbelt::Models::Hotel do

  it_behaves_like "ApiClass"

  describe "attributes" do

    it "includes #name" do
      expect(subject).to respond_to(:name)
    end

    it "includes #address1" do
      expect(subject).to respond_to(:address1)
    end

    it "includes #address2" do
      expect(subject).to respond_to(:address2)
    end

    it "includes #address3" do
      expect(subject).to respond_to(:address3)
    end

    it "includes #city" do
      expect(subject).to respond_to(:city)
    end

    it "includes #state" do
      expect(subject).to respond_to(:state)
    end

    it "includes #postal_code" do
      expect(subject).to respond_to(:postal_code)
    end

    it "includes #iso_code_country" do
      expect(subject).to respond_to(:iso_code_country)
    end

    it "includes #lng" do
      expect(subject).to respond_to(:lng)
    end

    it "includes #lat" do
      expect(subject).to respond_to(:lat)
    end

    it "includes #number_of_rooms" do
      expect(subject).to respond_to(:number_of_rooms)
    end

    it "includes #number_of_suites" do
      expect(subject).to respond_to(:number_of_suites)
    end

    it "includes #number_of_floors" do
      expect(subject).to respond_to(:number_of_floors)
    end

    %w{ has_valet_parking
        has_continental_breakfast
        has_in_room_movies
        has_sauna
        has_whirlpool
        has_voice_mail
        has_24hour_security
        has_parking_garage
        has_electronic_room_keys
        has_coffee_tea_maker
        has_safe
        has_video_check_out
        has_restricted_access
        has_interior_room_entrance
        has_exterior_room_entrance
        has_combination
        has_fitness_facility
        has_game_room
        has_tennis_court
        has_golf_course
        has_in_house_dining
        has_in_house_bar
        has_handicap_accessible
        has_children_allowed
        has_pets_allowed
        has_tv_in_room
        has_data_ports
        has_meeting_rooms
        has_business_center
        has_dry_cleaning
        has_indoor_pool
        has_outdoor_pool
        has_non_smoking_rooms
        has_airport_transportation
        has_air_conditioning
        has_clothing_iron
        has_wakeUp_service
        has_mini_bar_in_room
        has_room_service
        has_hair_dryer
        has_car_rent_desk
        has_family_rooms
        has_kitchen
        has_map }.each do |prop|
  
      it "includes ##{prop}" do
        expect(subject).to respond_to(prop.to_sym)
      end
    end




    describe "#name" do

      before{ subject.name = "Atlanta Hotel" }

      it "is a String" do
        expect(subject.name).to be_instance_of String
      end

    end

    describe "#address1" do

      before{ subject.address1 = "Am Strand 1" }

      it "is a String" do
        expect(subject.address1).to be_instance_of String
      end

    end

    describe "#address2" do

      before{ subject.address2 = "Am Strand 1" }

      it "is a String" do
        expect(subject.address2).to be_instance_of String
      end

    end

    describe "#address3" do

      before{ subject.address3 = "Am Strand 1" }

      it "is a String" do
        expect(subject.address3).to be_instance_of String
      end

    end

    describe "#city" do

      before{ subject.city = "Leipzig" }

      it "is a String" do
        expect(subject.city).to be_instance_of String
      end

    end

    describe "#state" do

      before{ subject.state = "Sachsen" }

      it "is a String" do
        expect(subject.state).to be_instance_of String
      end

    end

    describe "#postal_code" do

      before{ subject.postal_code = "04123" }

      it "is a String" do
        expect(subject.postal_code).to be_instance_of String
      end

    end

    describe "#lng" do

      before{ subject.lng = "86.345" }

      it "is a Float" do
        expect(subject.lng).to be_instance_of Float
      end

    end

    describe "#lat" do

      before{ subject.lat = "91.91" }

      it "is a Float" do
        expect(subject.lat).to be_instance_of Float
      end

    end

    describe "#number_of_rooms" do

      before{ subject.number_of_rooms = "43" }

      it "is a Integer" do
        expect(subject.number_of_rooms).to be_instance_of Fixnum
      end

    end

    describe "#number_of_suites" do

      before{ subject.number_of_suites = "12" }

      it "is a Integer" do
        expect(subject.number_of_suites).to be_instance_of Fixnum
      end

    end

    describe "#number_of_floors" do

      before{ subject.number_of_floors = "5" }

      it "is a Integer" do
        expect(subject.number_of_floors).to be_instance_of Fixnum
      end

    end

    %w{ has_valet_parking
        has_continental_breakfast
        has_in_room_movies
        has_sauna
        has_whirlpool
        has_voice_mail
        has_24hour_security
        has_parking_garage
        has_electronic_room_keys
        has_coffee_tea_maker
        has_safe
        has_video_check_out
        has_restricted_access
        has_interior_room_entrance
        has_exterior_room_entrance
        has_combination
        has_fitness_facility
        has_game_room
        has_tennis_court
        has_golf_course
        has_in_house_dining
        has_in_house_bar
        has_handicap_accessible
        has_children_allowed
        has_pets_allowed
        has_tv_in_room
        has_data_ports
        has_meeting_rooms
        has_business_center
        has_dry_cleaning
        has_indoor_pool
        has_outdoor_pool
        has_non_smoking_rooms
        has_airport_transportation
        has_air_conditioning
        has_clothing_iron
        has_wakeUp_service
        has_mini_bar_in_room
        has_room_service
        has_hair_dryer
        has_car_rent_desk
        has_family_rooms
        has_kitchen
        has_map }.each do |prop|

      describe "##{prop}" do

        before{ subject[prop] = "1" }

        it "is a Boolean" do
          expect(subject[prop]).to be_instance_of TrueClass
        end
      end
    end

  end
end