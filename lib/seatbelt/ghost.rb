module Seatbelt

  # Public: Handles calling and defining of API methods.
  #
  # Any class that should acts like a API Class have to include this module.
  #
  # class Flight
  #   include Seatbelt::Ghost
  #
  #   api_method  :estimated_flight_time
  #
  #   api_method  :find_flights,
  #               :scope => :class
  # end
  #
  # flight = Flight.new
  # flight.estimated_flight_time(:to => "London")
  # Flight.find_flights(:to => "London", :from => "Frankfurt")
  module Ghost

    def self.included(base)
      base.class_eval do
        [Pool::Api, ClassMethods].each { |mod| self.extend mod }
      end
    end

    module ClassMethods

      # Public: Calls a API class method. If the method isn't defined or
      # found in the class lookup table a Seatbelt::Errors::NoMethodError is
      # raised.
      #
      # If method is defined it passes the calling responsibility to the core
      # Callee module.
      #
      # method_name - the called methods name
      # *args       - the methods argument list
      # &block      - the methods block (this is optional)
      #
      # Returns the evaluted method value.
      def method_missing(method_name, *args, &block)
        unless self.lookup_tbl.has?(method_name, scope: :class)
          raise Seatbelt::Errors::NoMethodError
        end
        Seatbelt::Callee.handle(self,
                                { :lookup_tbl  => self.lookup_tbl,
                                  :scope       => :class,
                                  :method_name => method_name
                                },
                                *args,
                                &block)
      end

    end

    # Public: Calls a API instance method. If the method isn't defined or
    # found in the class lookup table a Seatbelt::Errors::NoMethodError is
    # raised.
    #
    # If method is defined it passes the calling responsibility to the core
    # Callee module.
    #
    # method_name - the called methods name
    # *args       - the methods argument list
    # &block      - the methods block (this is optional)
    #
    # Returns the evaluted method value.
    def method_missing(method_name, *args, &block)
      unless self.class.lookup_tbl.has?(method_name)
        raise Seatbelt::Errors::NoMethodError
      end
      Seatbelt::Callee.handle(self,
                              { :lookup_tbl  => self.class.lookup_tbl,
                                :scope       => :instance,
                                :method_name => method_name
                              },
                              *args,
                              &block)
    end

  end
end
