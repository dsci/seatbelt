module Seatbelt

  # Public: A Seatbelt::Proxy class is a shadow of any class that includes
  # Seatbelt::Gate.
  # It provides access to the API class or instance of the API class and
  # implements the DynamicProxy pattern.
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

    NOT_ALLOWABLE_CALLS_ON_OBJECT = %w{ call object klass tunnel }

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
      object.send(method_name,*args,&block)
    end

    def object
      self.send(:klass)
    end
    
    # Public: Calls a private API attribute or method of an object defined
    # in a API class. 
    #
    # It is only working on a second level.
    #
    # chain - The attribute call chain as String.
    #
    # Example:
    #
    # class ApiA
    #   include Seatbelt::Document
    #   include Seatbelt::Ghost
    #
    #   has :b, "Models::B"
    #
    # end
    #
    # class Models::B
    #   include Seatbelt::Document
    #   include Seatbelt::Ghost
    #
    #   # definitions
    #
    # end
    #
    # class ImplementationB 
    #   field :name, :type => String
    # end
    # 
    # In a implementation method of ApiA
    #
    # proxy.tunnel("b.name")
    #
    #
    # Returns the duplicated String.
    def tunnel(chain)
      proxy_associated_object,object_method = chain.split(".")
      unless object.respond_to?(proxy_associated_object) 
        raise Seatbelt::Errors::ObjectDoesNotExistError 
      else
        tunneled_object = object.send(proxy_associated_object)
        callees         = tunneled_object.eigenmethods.map do |eigenmethod|
          eigenmethod.send(:callee)
        end
      
        callee = callees.uniq.first
        unless callee.nil?
          unless object_method
            warn "You called a single object. Use #call instead." 
            object_method = proxy_associated_object
          end
          return callee.send(object_method)
        else
          raise Seatbelt::Errors::MethodNotImplementedError
        end
      end
    end

    # Public: Delegates a method message to the #object receiver if the
    # message is not included in NOT_ALLOWABLE_CALLS_ON_OBJECT or the
    # class responds to.
    def method_missing(method_name, *args, &block)
      unless method_name.to_s.in?(NOT_ALLOWABLE_CALLS_ON_OBJECT) &&
        (not self.respond_to?(method_name))
        self.call(method_name, *args, &block)
      else
        super
      end
    end

  end
end
