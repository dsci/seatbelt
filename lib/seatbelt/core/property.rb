module Seatbelt
  module Property
    module ClassMethods
      
      # Public: Defines an API property. This is only working if its called within
      # the #interface method block.
      #
      # Wraps Seatbelt::Pool::Api#api_method with a getter and setter method name.
      #
      # *args - An argument list containing:
      #         name    - Name of the API property (required)
      #         options - An optional options Hash containing:
      #                   :accessible - Property is mass assignable 
      #                                 (defaults to false)
      #
      # Examples:
      #
      #   class Book
      #     interface :instance do
      #       define_property :author
      #       define_property :title
      #     end
      #   end
      def define_property(*args)
        if @scope.eql?(:class)
          raise Seatbelt::Errors::PropertyOnClassLevelDefinedError
        end
        hsh         = {}
        options     = args.extract_options!
        accessible  = options.fetch(:accessible, false)
        name        = args.pop
        hsh[:scope] = @scope

        self.send(:api_method, name, hsh)
        hsh[:args] = [:value]
        self.send(:api_method, :"#{name}=", hsh)

        property_list << name
        self.send(:property_accessible, name) if accessible

      end

      # Public: Mass defining of properties.
      #
      # See #define_property for details
      #
      # - properties - A list of property names to define.
      #
      def define_properties(*properties)
        properties.each { |property| define_property(property) }
      end

      # Public: All properties that are marked as accessible.
      #
      # Returns the property list or an empty Array.
      def accessible_properties
        @accessible_properties ||= []
      end

      # Public: Defines one or more properties to be mass assignable due
      # the #properties= setter method.
      #
      # If the class implements an #attributes method (e.g. coming from 
      # Seatbelt::Document) these attributes are includeable in this list too.
      #
      # properties - A list of property names. Requires at least one property.
      #
      def property_accessible(*properties)
        properties.each do |property|
          attribute_defined = false
          if self.respond_to?(:attributes)  
            if self.attribute_set.map(&:name).include?(property)
              attribute_defined = true
            end 
          end
          unless attribute_defined 
            unless property_list.include?(property) && !attribute_defined
              raise Seatbelt::Errors::PropertyNotDefinedYetError.new(property)
            end
          end
          accessible_properties << property
        end
      end

      private

      # Internal: All properties of the class defined with #define_property.
      #
      # Returns the the properties as Array or an empty Array.
      def property_list
        @property_list ||= []
      end

    end

    module InstanceMethods

      require 'active_support/core_ext/hash/keys'

      # Public: Gets a list of key-value pairs that includes the properties
      # with its values.
      #
      # role -  The scope of properties that will be selected 
      #         Defaults to :accessibles which will only select properties that 
      #         are defined as accessible.
      #
      # Returns an Hash containing the property names and its values. 
      def properties(role = :accessibles)
        injector = lambda do |result, item|
          result[item] = self.send(item)
          result
        end
        list = case role
          when :accessibles then
            self.class.accessible_properties.inject({}, &injector)
          when :all then
            all = self.class.send(:property_list).inject({}, &injector)
            all.merge!(attributes) if self.respond_to?(:attributes)
            all
          else
            {}
        end
        list.with_indifferent_access
      end

      # Public: Sets a bunch of properties that are marked as accessible.
      #
      # property_hsh -  The Hash containing the property name and the property 
      #                 value.
      #
      # Examples
      #
      #   class Car
      #     include Seatbelt::Ghost
      #
      #     interface :instance do 
      #       define_property :wheels
      #       define_property :color
      #       
      #       property_accessible :color
      #     end
      #   end
      #   
      #   car = Car.new
      #   car.properties = { :color => "yellow", :wheels => 3 }
      #   
      #   car.color   # => 'yellow' because it's accessible
      #   car.wheels  # => nil because it's not accessible
      #
      def properties=(property_hsh)
        property_hsh.each do |property_key, property_value|
          if self.class.accessible_properties.include?(property_key) || \
            self.class.accessible_properties.map(&:to_s).include?(property_key)
            self.send("#{property_key}=", property_value)
          end
        end
      end

    end
  end
end