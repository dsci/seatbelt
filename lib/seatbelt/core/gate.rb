module Seatbelt

  # Public: Module that provides method forward declaration named :implement.
  #
  module Gate

    def self.included(base)
      base.class_eval{ extend ClassMethods }
    end

    module ClassMethods

      def method_added(name)
        #TODO implement me!
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

        config        = {
          :method         => instance_method(method).bind(self.new),
          :implemented_as => remote_method,
          :namespace      => namespace,
          :scope          => method_scope
        }
        Terminal.luggage << config
      end

    end
  end
end