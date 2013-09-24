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

      # Public: Initializes the collections primitive to allow later type
      # checking.Adds a method 'acceptable_item_name' to the primitive, that
      # is later called at the time of type checking to match the allowed class.
      #
      # klass - The associatzed klass that is insertable into the collection.
      #
      def self.initialize_primitive(klass)
        default_primitive = primitive.new
        default_primitive.class_eval <<-RUBY, __FILE__, __LINE__
          def acceptable_item_name
            return "#{klass.name}"
          end
        RUBY
        default default_primitive
      end

      primitive.class_eval do
        def <<(item)
          case item.class.name
          when acceptable_item_name then super(item)
          when "Hash" then
            begin
              super(Module.const_get(acceptable_item_name).new(item))
            end
          else
            raise Seatbelt::Errors::TypeMissmatchError.
                                    new(acceptable_item_name,
                                        item.class.name)
          end
       end
      end

    end
  end
end
