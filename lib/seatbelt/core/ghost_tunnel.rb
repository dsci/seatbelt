module Seatbelt

  # Public: Provides switches to enable accessing the implementation instance
  # of an API class instances.
  #
  # Any API class that implements Seatbelt::Ghost can have access to its
  # implementation class instance. This behaviour has to be enabled before using
  # because its a violation of the Public/Private API approach.
  #
  # (And yes - in Ruby private methods are not really private methods.)
  #
  # Accessing the implementation instance is only available after the API Class
  # was instantiated.
  #
  # Example:
  #
  # class Hotel
  #   include Seatbelt::Ghost
  #
  #   enable_tunneling! # access to the implementation instance is not
  #                     # possible.
  #
  # end
  #
  # class ImplementationHotel
  #   include Seatbelt::Document
  #   include Seatbelt::Gate
  #
  #   attribute :ignore_dirty_rooms, Boolean
  #
  # end
  #
  # hotel = new Hotel
  # hotel.tunnel(:ignore_dirty_rooms=,false)
  #
  # Passing blocks is also available if the accessed method supports blocks
  #
  # class ImplementationHotel
  #   include Seatbelt::Document
  #   include Seatbelt::Gate
  #
  #   attribute :ignore_dirty_rooms, Boolean
  #
  #   def filter_rooms(sections)
  #     rooms = self.rooms.map{|room| sections.include?(room_type)}
  #     yield(rooms)
  #   end
  # end
  #
  # hotel.tunnel(:filter_rooms, ["shower, kitchen"]) do |rooms|
  #   rooms.select do |room|
  #     # do something
  #   end
  # end
  module GhostTunnel
    extend self

    # Public: Enables tunnel support for an instance of API class.
    #
    # Defines the #tunnel method.
    def enable_tunneling!
      define_method :tunnel do |name, *args, &block|
        callees = self.eigenmethods.map{|n| n.instance_variable_get(:@callee)}
        unless callees.empty?
          callee = callees.first
          callee.send(name, *args, &block)
        end
      end
    end

    # Public: Disables tunnel support for an instance of API class.
    #
    # Removes the #tunnel method defined in #enable_tunneling! .
    def disable_tunneling!
      if self.instance_methods.include?(:tunnel)
        remove_method(:tunnel)
      end
    end

  end
end