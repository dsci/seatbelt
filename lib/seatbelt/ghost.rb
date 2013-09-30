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
        [Pool::Api, EigenmethodStore, ClassMethods].each { |m| self.extend m }
        include EigenmethodStore

        class << self

          alias_method :_new, :new
          # Public: Overrides the Class#new method to create the class instance
          # eigenmethods.
          #
          # *args - An argumentlist passed to #initialize
          #
          # Returns the instance.
          def new(*args)
            obj = _new(*args)
            namespace = obj.class.name
            eigenmethods_for_scope = Terminal.
                                     for_scope_and_namespace(:instance,
                                                             namespace)
            unless eigenmethods_for_scope.empty?
              proxy = Seatbelt::Proxy.new
              receiver = eigenmethods_for_scope.first.receiver.new
              eigenmethods_for_scope.each do |eigenmethod|
                options = {:eigenmethod => eigenmethod,
                           :object      => obj,
                           :receiver    => receiver,
                           :return_method => true,
                           :add_to      => false
                          }
                obj.eigenmethods << Seatbelt::EigenmethodProxy.set(proxy, options)
              end
            end
            return obj
          end
        end

      end
    end

    module EigenmethodStore

      def eigenmethods
        @eigenmethods ||= []
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
        unless self.respond_to?(method_name)
          raise Seatbelt::Errors::NoMethodError
        end
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
