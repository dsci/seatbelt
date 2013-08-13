module Seatbelt

  # Public: Interface between API class and Implementation class.
  # Calls the implementation of an API method with passed arguments and block.
  #
  class Terminal
    # The implementation methods config store.
    cattr_writer :luggage

    # Public: The implementation methods config store.
    #
    # Returns implementation methods config store.
    def self.luggage
      @luggage ||= []
    end


    # Public: calls the implementation of an API method with passed arguments
    # and block.
    #
    # action  -   The API method name to be called
    # klass   -   The API class name on which the API method is declared
    # *args   -   An argument list passed to the implementation method
    # &block  -   An optional block passed to the implementation method.
    #
    # Returns the return value of the implementation method.
    def self.call(action, klass, *args, &block)
      raise Seatbelt::Errors::MethodNotImplementedError if luggage.empty?
      scope               = klass.class.eql?(Class) ? :class : :instance
      klass_namespace     = scope.eql?(:class) ? klass.name : klass.class.name
      action_implemented  = luggage.detect do |package|
        package[:implemented_as].eql?(action) && package[:scope].eql?(scope) \
        && package[:namespace].eql?(klass_namespace)
      end
      unless action_implemented
        raise Seatbelt::Errors::MethodNotImplementedError
      end
      action_implemented[:method].call(*args, &block)
    end

  end
end