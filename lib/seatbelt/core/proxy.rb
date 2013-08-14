module Seatbelt

  # Public: A Seatbelt::Proxy class is a shadow of any class that includes
  # Seatbelt::Gate.
  # It provides access to the API class or instance of the API class.
  #
  # A Proxy class provides a private dynamic accessor #klass that changes with
  # the implementation scope of the API methods implementation.
  #
  # Let's show this by example:
  #
  # class ApiClass
  #   include Seatbelt::Ghost
  #
  #   api_method :an_instance_method_to_implement
  #   api_method :a_class_method_to_implement
  #   def helper(a,b,c)
  #     #....
  #   end
  #
  #   def self.c_helper(options={})
  #     # ...
  #   end
  # end
  #
  # class ApiClassImplementation
  #
  #   def instance_implementation
  #     local = proxy.call(:helper, 1,2,4) # proxy scope is instance of ApiClass
  #   end
  #   implement :instance_implementation,
  #             :as => "ApiClass#an_instance_method_to_implement"
  #
  #   def class_implementation
  #     local = proxy.call(:c_helper, {:foo => 19})
  #     # proxy scope is ApiClass
  #   end
  #   implement :class_implementation,
  #             :as => "ApiClass.a_class_method_to_implement"
  # end
  class Proxy

    # Public: Send a method message to the current #klass scope receiver.
    # See class documentation section for further informations about #klass.
    #
    # method_name - The method to call
    # *args       - The methods argument list
    # &block      - An optional block that should be passed to the callable
    #               method
    #
    # Returns the return value of the callable method or raises a
    # NoMethodError.
    def call(method_name, *args, &block)
      self.send(:klass).send(method_name,*args,&block)
    end
  end
end