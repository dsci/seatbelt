module Seatbelt
  module EigenmethodProxy
    extend self

    # Public: Creates or duplicates a new eigenmethod object. Creates the proxy
    # object on the Eigenmethod and adds this eigenmethod object to
    # Terminal#luggage or just returns the duplicated or thenewly created object
    #
    # *args - An argument list consisting of:
    #         proxy   - A Seatbelt::Proxy instance
    #         options - An options hash
    #           :eigenmethod    - the eigenmethod to duplicate
    #           :object         - the object the eigenmethod should be bind to
    #           :receiver       - An instance or class representation of the
    #                             implementation class
    #           :add_to         - Eigenmethod should added to Terminal#luggage
    #                             (defaults to true)
    #           :return method  - Eigenmethod should be returned
    #
    def set(*args)
      options         = args.extract_options!
      proxy           = args.pop
      eigenmethod     = options[:eigenmethod]
      obj             = options[:object]
      receiver        = options[:receiver]
      index           = Terminal.luggage.index(eigenmethod)
      add_to_luggage  = options.fetch(:add_to, true)
      return_method   = options.fetch(:return_method, false)

      new_eigenmethod = eigenmethod.dup

      ivar_callee = receiver
      ivar_callee.instance_variable_set(:@proxy, proxy)
      new_eigenmethod.instance_variable_set(:@callee,ivar_callee)
      new_eigenmethod.init_klass_on_receiver(obj) if obj

      if add_to_luggage
        Terminal.luggage.delete(eigenmethod)
        Terminal.luggage << new_eigenmethod
      end

      return new_eigenmethod if return_method
    end
  end
end
