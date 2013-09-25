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
    # *args   - argument list for the implementation method.
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


    # Creates the corrosponding class on the receiver and defines the proxy
    # tunnel on the receivers proxy object.
    #
    # klass_object -The API Class or an instance of the API class.
    #
    def init_klass_on_receiver(klass_object)
      @callee = receiver.new
      if instance_level?
      __generate_proxy_object(@callee, klass_object)
      end
      if class_level?
        initilizor = lambda do |receiver_scope|
          receiver_scope.class.send(:proxy_object).
                              instance_variable_set(:@klass, klass_object)
          receiver_scope.class.send(:proxy_object).class_eval code
          receiver_scope.class.send(:define_method, :proxy) do
            return self.class.proxy_object
          end
          return receiver_scope
        end

        if class_method_implementation?
           __generate_proxy_object(receiver, klass_object)
        else
          @callee = initilizor.call(@callee)
        end
      end

    end


    # Accessor of the api method implementation call object.
    def callee
      @callee
    end

    def __generate_proxy_object(receiver_, klass_object)
      runner = lambda do |receiver_scope|
        receiver_scope.send(:proxy_object).instance_variable_set(:@klass, klass_object)
        receiver_scope.send(:proxy_object).class_eval code
        receiver_scope.class.send(:define_method, :proxy) do
          return self.proxy_object
        end
        return receiver_scope
      end
      runner.call(receiver_)
      #return receiver_scope
    end

    def code
      <<-RUBY
        def klass
          return instance_variable_get(:@klass)
        end
        private :klass
      RUBY
    end

    def __send_class_level(*args, &block)
      if class_method_implementation?
        callee = receiver
      else
        callee = receiver.new
      end
      callee.send(@method, *args, &block)
    end

    def __send_instance_level(*args, &block)
      if method.respond_to?(:bind)
        value = method.bind(callee).call(*args, &block)
      else
        value = callee.send(method, *args, &block)
      end
    end

    private :callee,
            :__send_instance_level,
            :__send_class_level,
            :__generate_proxy_object,
            :code

  end
end