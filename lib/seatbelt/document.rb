module Seatbelt

  # Public: A Document is an interface to specify attributes for a API class.
  # Accessing and setting attributes for an API class within an implementation
  # class is possible during the proxy object.
  #
  # Example:
  #
  # class Airport
  #   include Seatbelt::Ghost
  #   include Seatbelt::Document
  #
  #   attribute :name,  String
  #   attribute :lat,   Float
  #   attribute :lng,   Float
  #
  #   api_method :identifier
  #
  # end
  #
  # class ImplementationKlass
  #   include Seatbelt::Gate
  #
  #   def aiport_identifier
  #     name = proxy.call(:name) # <= calls the Aiport attribute
  #     return "airport_#{name}".underscore
  #   end
  #   implement :airport_identifier, :as => "Airport#identifier"
  # end
  #
  # aiport = Airport.new(:name => "London Stansted")
  # airport.identifier # => "airport_london_stansted"
  #
  # For more information about definining and working with attributes see
  # 'Virtus' project page: https://github.com/solnic/virtus
  #
  # To have validations for attributes just implement ActiveModel validations.
  # For more informations about that see the ActiveModel validations docs:
  # http://api.rubyonrails.org/classes/ActiveModel/Validations.html
  #
  # Example
  #
  # class Airport
  #   include Seatbelt::Ghost
  #   include Seatbelt::Document
  #
  #   attribute :name,  String
  #   attribute :lat,   Float
  #   attribute :lng,   Float
  #
  #   validates_presence_of :name
  #
  #   api_method :identifier
  #
  #  end
  module Document

    def self.included(base)
      base.class_eval do
        include ::Virtus
        include ::ActiveModel::Validations
      end
    end
  end
end