module Seatbelt

  # Public: Module that provides method forward declaration named :implement.
  #
  module Gate

    def self.included(base)
      base.class_eval do
        include Proxy
        extend ClassMethods
        private_class_method :implementation_methods
      end
    end

    module Proxy

      # Public: Access the implementation class Proxy class instance.
      # If there is no Proxy class instance defined, a new instance will
      # be initialized.
      #
      # Returns the proxy class instance.
      def proxy
        @proxy = Seatbelt::Proxy.new unless defined?(@proxy)
        @proxy
      end

    end

    module ClassMethods
      include Gate::Proxy

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
      def implement_class(*args)
        options = args.extract_options!
        klass   = args.pop
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

        if method_scope.eql?(:instance)
          method    = instance_method(method)
        end
        receiver    = self.new

        method_proxy                            = Seatbelt::MethodProxyObject.
                                                                          new
        method_proxy.method                     = method
        method_proxy.scope_level                = method_scope
        method_proxy.namespace                  = namespace
        method_proxy.implemented_as             = remote_method
        method_proxy.receiver                   = receiver
        method_proxy.method_implementation_type = type

        Terminal.luggage << method_proxy
      end

    end
  end
end
