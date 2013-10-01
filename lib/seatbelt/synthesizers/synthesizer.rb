module Seatbelt

  # Public: The Synthesizer base module which provides attribute based
  # synthesizing between a proxy and an implementation object.
  #
  # To create a Synthesizer include this module in a plain Ruby class and
  # implement the #synthesizable_attributes method.
  #
  # Example
  #
  #   class BookSynthesizer
  #     include Seatbelt::Synthesizer
  #
  #     def synthesizable_attributes
  #       [:title, :publisher]
  #     end
  #   end
  #
  #
  #   class Book
  #     include Seatbelt:Document
  #     include Seatbelt::Ghost
  #
  #     attribute :title,     String
  #     attribute :publisher, String
  #     attribute :author,    String
  #
  #     api_method :sell
  #   end
  #
  #   class ImplementationBook < ActiveRecord::Base
  #     include Seatbelt::Gate
  #
  #     synthesize :from    => "Book",
  #                :adapter => "BookSynthesizer"
  #   end
  module Synthesizer

    attr_reader :synthesizable_object

    # Public: Initializes the Synthesizer.
    #
    # from_klass            - The API Class
    # synthesizable_object  - The implementation class instance
    def initialize(from_klass, synthesizable_object)
      @klass                = from_klass
      @synthesizable_object = synthesizable_object
    end

    # Public: Defines the attribute based synthesize mechanism by redefining the
    # getter and setter methods of the implementation class instance.
    #
    def synthesize
      unless self.respond_to?(:synthesizable_attributes)
        raise Seatbelt::Errors::SynthesizeableAttributesNotImplementedError
      end
      if @synthesizable_object.class.respond_to?(:synthesize_map)
        if @synthesizable_object.class.synthesize_map.empty?
          __synthesize_without_map
        else
          __synthesize_with_map
        end
      else
        __synthesize_without_map
      end
    end

    # Defines synthesizing with the same proxy object attributes and
    # implementation class instance attributes.
    #
    def __synthesize_without_map
      @klass.attribute_set.each do |attr|
        attribute_name = attr.name
        if attribute_name.in?(__synthesizable_attribute_names)
          __redefine_setter(@synthesizable_object, attribute_name)
          __redefine_getter(@synthesizable_object, attribute_name)
        end
      end
    end

    # Defines synthesizing by considering the presence of a synthesize map of
    # proxy and implementation attributes.
    def __synthesize_with_map
      map = @synthesizable_object.class.synthesize_map
      @klass.attribute_set.each do |attr|
        attribute_name = attr.name
        if attribute_name.in?(map.keys)
          object_attribute_name = map[attribute_name]
          __redefine_setter(@synthesizable_object, object_attribute_name,
                            attribute_name)
          __redefine_getter(@synthesizable_object, object_attribute_name,
                            attribute_name)
        end
      end
    end

    def __synthesizable_attribute_names
      if synthesizable_attributes.is_a?(Hash)
        return synthesizable_attributes.keys
      else
        return synthesizable_attributes
      end
    end

    def __redefine_getter(on_object, attribute, klass_attribute_name=nil)
      if klass_attribute_name.nil?
        klass_attribute_name = attribute
      end
      getter_code = <<-RUBY
        class << self
          alias_method :_#{attribute}, :#{attribute}
          #alias_method "_#{attribute}=", "#{attribute}="
        end
        def #{attribute}
          self.send("#{attribute}=", proxy.send("#{klass_attribute_name}"))
          return self.send("_#{attribute}")
        end
      RUBY
      on_object.instance_eval getter_code, __FILE__, __LINE__
    end

    def __redefine_setter(on_object, attribute, klass_attribute_name=nil)
      if klass_attribute_name.nil?
        klass_attribute_name = attribute
      end
      setter_code = <<-RUBY
        class << self
          #alias_method :_#{attribute}, :#{attribute}
          alias_method "_#{attribute}=", "#{attribute}="
        end

        def #{attribute}=(value)
          proxy.send("#{klass_attribute_name}=",value)
          self.send("_#{attribute}=",value)
        end
      RUBY
      on_object.instance_eval setter_code, __FILE__, __LINE__
    end

    private :__synthesizable_attribute_names,
            :__redefine_getter,
            :__redefine_setter,
            :__synthesize_without_map,
            :__synthesize_with_map
  end
end