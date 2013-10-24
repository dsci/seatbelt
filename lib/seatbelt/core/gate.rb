module Seatbelt

  # Public: Module that provides method forward declaration named :implement.
  #
  module Gate

    def self.included(base)
      base.class_eval do
        include Proxy
        extend Synthesizeable
        extend ClassMethods
        private_class_method :implementation_methods,
                             :eigenmethods_class_level
      end
    end

    module Proxy

      # Public: Access the implementation class Proxy class instance.
      # If there is no Proxy class instance defined, a new instance will
      # be initialized.
      #
      # Returns the proxy class instance.
      def proxy_object
        @proxy
      end

    end

    module ClassMethods
      include Gate::Proxy
      include Gate::Implementation

      # Internal: Collection of implementation methods configurations defined
      # with the #implement_class directive.
      def implementation_methods
        @impl_methods ||= []
      end

      # Public: Ruby hook to check if a method that is added to the class was
      # defined with the #implement_class directive. If so, it calls the
      # #implement method. For further information see their method documention.
      #
      # name - the method name as Symbol
      def method_added(name)
        implementation_method = implementation_methods.detect do |method_config|
          name.in?(method_config.keys)
        end
        if implementation_method
          config = implementation_method.values.pop
          method = self.instance_method(name).bind(self.new)
          config[:method] = method
          implement(name, config)
        end
      end

      # Public: Adds a bunch of method forward declaration object to for a
      # specific class.
      # Later it calls #implement during #method_added.
      #
      # *args - An argument list containing:
      #
      # Returns the duplicated String.
      #
      # Deprecates that in future versions!
      def implement_class(*args)
        warn "Calling #implement_class will be deprecated in Seatbelt 1.0."
        options   = args.extract_options!
        klass     = args.pop
        only      = options[:only]
        iterator  = Core::Iterators::MethodConfig.
                      send("#{only.class.name.downcase}_method_iterator",klass,
                           self)
        only.each(&iterator)
      end

      # Public: Adds a method forward declaration object to a method config
      # stack in Seatbelt::Terminal#luggage.
      #
      # *args - An argument list containing:
      #         * method -  The method name that should be forwarded (or marked
      #                     as implementation of a remote method)
      #         * options - A options Hash to configure to which method the
      #                     implementation should be forwarded:
      #                     :as - A String containing the remote class'
      #                           namespace followed by a method directive
      #                           identifier and the remote method name
      #
      # Example:
      #
      #   implement :support_agility, :as => "Rails::Conference#workshop"
      #
      # Forwards the implementation method support_agility to the instance
      # method #workshop of the class Conference within the module Rails.
      #
      #   implement :check_speakers, :as => "Rails::Conference.invite_speakers"
      #
      # Forwards the implementation method :check_speakers to the class method
      # #invite_speakers of the class Conference within the module Rails.
      #
      # This will be private in Seatbelt 1.0.
      def implement(*args)
        options       = args.extract_options!
        method        = args.pop
        remote_method = options[:as]
        method_scope  = :class     if remote_method.include?(".")
        method_scope  = :instance  if remote_method.include?("#")
        directive     = Seatbelt::GateConfig.method_directives[method_scope]
        scope_chain   = remote_method.split(directive)
        remote_method = scope_chain.pop.to_sym
        namespace     = scope_chain.shift
        type          = options.fetch(:type, :instance)

        receiver      = self

        method_proxy                            = Seatbelt::Eigenmethod.new
        method_proxy.method                     = method
        method_proxy.scope_level                = method_scope
        method_proxy.namespace                  = namespace
        method_proxy.implemented_as             = remote_method
        method_proxy.receiver                   = receiver
        method_proxy.method_implementation_type = type
        #method_proxy.arity                      = method.arity

        if method_scope.eql?(:instance)
          method    = instance_method(method)
          method_proxy.arity = method.arity
        else
          method_proxy = eigenmethods_class_level(namespace,method_proxy)
        end
        Terminal.luggage << method_proxy
      end

      # Internal: Defines the Eigenclass method proxy object.
      #
      # This is only called if an implementation class implements a class
      # method of its API class. Adds the method proxy to the eigenclass
      # eigenmethods bucket.
      #
      # namespace     - The API class name
      # method_proxy  - The MethodProxy skeleton created by #implement
      #
      # Returns the method proxy.
      def eigenmethods_class_level(namespace,method_proxy)
        receiver          = self
        options           = { :eigenmethod   => method_proxy,
                              :receiver      => receiver,
                              :add_to        => false,
                              :return_method => true
                            }
        proxy             = Seatbelt::Proxy.new
        method_proxy      = Seatbelt::EigenmethodProxy.set(proxy, options)
        klass             = Module.const_get(method_proxy.namespace)

        method_proxy.init_klass_on_receiver(klass)
        method_proxy.arity = method_proxy.instance_variable_get(:@callee).
                                              method(method_proxy.method).arity
        klass.eigenmethods << method_proxy
        return method_proxy
      end

    end
  end
end
