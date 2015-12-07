module Seatbelt

  # Public: Interface between API class and Implementation class.
  # Calls the implementation of an API method with passed arguments and block.
  #
  class Terminal
    # The implementation methods config store.
    def self.luggage=(luggage_pack)
      @luggage = luggage_pack
    end

    # Public: The implementation methods config store.
    #
    # Returns implementation methods config store.
    def self.luggage
      @luggage ||= []
    end

    def self.for_scope_and_namespace(scope, namespace)
      Terminal.luggage.select do |package|
        package.scope_level.eql?(scope) && package.namespace.eql?(namespace)
      end
    end


    # Public: calls the implementation of an API method with passed arguments
    # and block.
    # Before sending the method message to the receiver, it defines the
    # receivers proxy scope depending on klass (see below).
    #
    # action  -   The API method name to be called
    # klass   -   The API class name on which the API method is declared
    # arity   -   Number of required arguments
    # *args   -   An argument list passed to the implementation method
    # &block  -   An optional block passed to the implementation method.
    #
    # Returns the return value of the implementation method.
    def self.call(action, klass, arity, *args, &block)
      raise Seatbelt::Errors::MethodNotImplementedError if luggage.empty?
      scope               = klass.class.eql?(Class) ? :class : :instance
      klass_namespace     = scope.eql?(:class) ? klass.name : klass.class.name

      eigenmethod = klass.eigenmethods.detect do |meth|
        meth.implemented_as.eql?(action)
      end

      unless eigenmethod
        raise Seatbelt::Errors::MethodNotImplementedError
      end

      if (not eigenmethod.delegated) && (not eigenmethod.arity.eql?(arity))
        raise Seatbelt::Errors::ArgumentMissmatchError
      end

      eigenmethod.call(*args, &block)
    end

  end
end
