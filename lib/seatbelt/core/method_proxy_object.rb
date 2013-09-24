module Seatbelt

  # Public: A configuration class that contains the implementation method
  # directives and attributes.
  class MethodProxyObject

    attr_accessor :scope_level,
                  :namespace,
                  :implemented_as,
                  :method,
                  :method_implementation_type

    attr_writer   :receiver


    # Public: The receiver of the implementation method. This is always an
    # instance whether it defines a class method or instance method
    # implementation.
    #
    # Returns receivers instance.
    def receiver
      @receiver
    end


    # Implementation type at remote class (API class) side.
    #
    # Returns true if an instance method is implemented, otherwise false.
    def instance_level?
      self.scope_level.eql?(:instance)
    end

    # Implementation type at remote class (API class) side.
    #
    # Returns true if a class method is implemented, otherwise false.
    def class_level?
      not self.instance_level?
    end

    # Implementation type at the implementation class side.
    #
    # Returns true if a class method is implemented, otherwise false.
    def class_method_implementation?
      self.method_implementation_type.eql?(:class)
    end

    # Implementation type at the implementation class side.
    #
    # Returns true if an instance method is implemented, otherwise false.
    def instance_method_implementation?
      not class_method_implementation?
    end


    # Public: Calls the implementation method of an API method call.
    #
    # *args   -argument list for the implementation method.
    # &block  - A block if needed.
    #
    # Returns the evaluated value.
    def call(*args, &block)
      return __send_class_level(*args, &block) if class_level?
      return __send_instance_level(*args, &block) if instance_level?
    end

    def [](attr)
      self.send(attr)
    end

    alias_method :has_key?, :respond_to?
    alias_method :scope, :scope_level
    alias_method :scope=, :scope_level=

    private

    def __send_class_level(*args, &block)
      if class_method_implementation?
        callee = receiver.class
      else
        callee = receiver
      end
      #p callee
      callee.send(@method, *args, &block)
    end

    def __send_instance_level(*args, &block)
      if method.respond_to?(:bind)
        value = method.bind(receiver).call(*args, &block)
      else
        value = receiver.send(method, *args, &block)
      end
    end

  end
end