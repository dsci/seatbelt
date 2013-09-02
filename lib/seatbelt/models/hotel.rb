module Seatbelt
  module Models

    # Public: Abstraction of Hotel
    class Hotel
      include Seatbelt::Ghost
      include Seatbelt::Document

      attribute :name,              String
      attribute :address1,          String
      attribute :address2,          String
      attribute :address3,          String
      attribute :city,              String
      attribute :state,             String
      attribute :postal_code,       String
      attribute :iso_code_country,  String
      attribute :lng,               Float
      attribute :lat,               Float
      attribute :number_of_rooms,   Integer
      attribute :number_of_suites,  Integer
      attribute :number_of_floors,  Integer

      attribute :has_valet_parking,           Boolean
      attribute :has_continental_breakfast,   Boolean
      attribute :has_in_room_movies,          Boolean
      attribute :has_sauna,                   Boolean
      attribute :has_whirlpool,               Boolean
      attribute :has_voice_mail,              Boolean
      attribute :has_24hour_security,         Boolean
      attribute :has_parking_garage,          Boolean
      attribute :has_electronic_room_keys,    Boolean
      attribute :has_coffee_tea_maker,        Boolean
      attribute :has_safe,                    Boolean
      attribute :has_video_check_out,         Boolean
      attribute :has_restricted_access,       Boolean
      attribute :has_interior_room_entrance,  Boolean
      attribute :has_exterior_room_entrance,  Boolean
      attribute :has_combination,             Boolean
      attribute :has_fitness_facility,        Boolean
      attribute :has_game_room,               Boolean
      attribute :has_tennis_court,            Boolean
      attribute :has_golf_course,             Boolean
      attribute :has_in_house_dining,         Boolean
      attribute :has_in_house_bar,            Boolean
      attribute :has_handicap_accessible,     Boolean
      attribute :has_children_allowed,        Boolean
      attribute :has_pets_allowed,            Boolean
      attribute :has_tv_in_room,              Boolean
      attribute :has_data_ports,              Boolean
      attribute :has_meeting_rooms,           Boolean
      attribute :has_business_center,         Boolean
      attribute :has_dry_cleaning,            Boolean
      attribute :has_indoor_pool,             Boolean
      attribute :has_outdoor_pool,            Boolean
      attribute :has_non_smoking_rooms,       Boolean
      attribute :has_airport_transportation,  Boolean
      attribute :has_air_conditioning,        Boolean
      attribute :has_clothing_iron,           Boolean
      attribute :has_wakeUp_service,          Boolean
      attribute :has_mini_bar_in_room,        Boolean
      attribute :has_room_service,            Boolean
      attribute :has_hair_dryer,              Boolean
      attribute :has_car_rent_desk,           Boolean
      attribute :has_family_rooms,            Boolean
      attribute :has_kitchen,                 Boolean
      attribute :has_map,                     Boolean

    end
  end
end