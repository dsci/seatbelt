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
  #
  # For associations between Documents see Association module below.
  module Document

    def self.included(base)
      base.class_eval do
        include ::Virtus
        include ::ActiveModel::Validations
        extend Document::Associations
      end
    end


    # Associations are a set of macro-like class methods for tying Ruby objects
    # together.
    # Each macro adds a getter and setter method that expresses the realtionship
    # depending on its type.
    # A 'has_many' relation defines an Array of models that also acts just the
    # same as the definition says.
    # A 'has' relation defines a single relation to another Ruby object.
    #
    # Note that every Class used for associations has to include
    # Seatbelt::Document.
    #
    # A little bit more about 'has_many':
    #
    # The resulting 'has_many' Array is an abstraction of
    # Virtus::Attribute::Collection.
    #
    # If it's defined
    #
    # has_many :horses, Horse
    #
    # Seatbelt awaits a collection definition like:
    #
    # module Seatbelt
    #   module Collections
    #     class HorseCollection < Seatbelt::Collections::Collection
    #       # do smth
    #     end
    #   end
    # end
    #
    # The most important part is the collections namespace, it should be
    # prefixed with Seatbelt::Collections. The collection itself has to
    # implement a Virtus::Attribute.
    #
    module Associations

      # Public: Defines a 1:n association.
      #
      # That is - in fact - an Array of models. There is no "other side" like
      # it's known from ActiveRecord or Mongoid.
      #
      # collection_name   - The name of the collection. That will be also the
      #                     name of accessor method.
      # collection_model -  The model class used for this collection.
      #
      # The resulting accessor method as like an Array, with some features:
      #
      # Adding a model to the relationship awaits an instance of the class
      # defined in 'collection_model' (otherwise a
      # Seatbelt::Errors::TypeMissmatchError is raised) or a hash of attribute
      # values. Any attributes included in this Hash that are not defined
      # within the model are ignored.
      #
      # Example
      #
      #   module HorseFarm
      #     module Models
      #       class Barnstable
      #         include Seatbelt::Document
      #
      #         has_many :horses, HorseFarm::Models::Horse
      #
      #       end
      #     end
      #   end
      def has_many(collection_name, collection_model)
        model_name              = collection_model.name.to_s.demodulize
        collection_module_name  = "Seatbelt::Collections::#{model_name}Collection"
        collection              = Module.const_get(collection_module_name)
        collection.model_class  = collection_model
        self.send(:attribute, collection_name, collection)
      end

      # Public: Defines a single reference to another Seatbelt::Document class.
      #
      # reference_name        - The name of the reference that will be also the
      #                         name of accessor method
      # attribute_type = nil  - The reference attribute type (optional).
      #                         If the attribute type if omitted
      #                         Seabelt::Models::[reference_name class name] is
      #                         used.
      #
      # Example
      #
      #   module HorseFarm
      #     module Models
      #       class Horse
      #         include Seatbelt::Document
      #
      #         # needs Seatbelt::Models::Horse
      #         has :horseman
      #         has :barnstable, HorseFarm::Models::Barnstable
      #       end
      #     end
      #   end
      #
      def has(reference_name, attribute_type = nil)
        unless attribute_type
          attribute_type = "Seatbelt::Models::#{reference_name.to_s.classify}".
                            constantize
        end
        self.send(:attribute, reference_name, attribute_type)
      end

    end
  end
end
