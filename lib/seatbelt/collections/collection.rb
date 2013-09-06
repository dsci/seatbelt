module Seatbelt
  module Collections
    
    # Public: The datastructure used as primitive  in
    # Seatbelt::Collections::Collection
    #
    class Array < ::Array; end

    # Public: The base collection attribute type that is used in 'has_many'
    # associations.
    #
    # Needs a corrosponding model.
    # See Seatbelt::Dcoument::Associations for further details.
    class Collection < Virtus::Attribute::Collection
      primitive       Seatbelt::Collections::Array
      coercion_method :to_array
      default         primitive.new

      cattr_reader    :model_class

      # Sets the assoictaed model class and overrides the primitive's #<<
      # method to have type check and hash attribute values working.
      # 
      # model_class - The model class used within the collection.
      #
      # Returns nothing
      def self.model_class=(model_class)
        @model_class = model_class

        primitive.class_eval <<-RUBY, __FILE__, __LINE__
          # Public: Adds an object to the 'has_many' association.
          #
          # item - An instance of the model class used within the collection
          #        or an Hash with attribute key/value pairs.
          #
          # Example
          #   region.hotels << {:name => "Radisson London Stansted"}
          #   region.hotels << super_hotel_in_dubai
          #
          # Raises Seatbelt::Errors::TypeMissmatchError if unexpected object
          # is passed.
          def <<(item)
            case item.class.name
            when "#{@model_class.name}" then super(item)
            when "Hash" then
              begin
                super(Module.const_get("#{@model_class.name}").new(item))
              end
            else
              raise Seatbelt::Errors::TypeMissmatchError.
                                      new("#{@model_class.name}",
                                          item.class.name)
            end
          end
        RUBY

      end

    end
  end
end
