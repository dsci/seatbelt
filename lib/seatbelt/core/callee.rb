module Seatbelt

  # Public: Handles passing the call of API Methods to the Terminal.
  module Callee
    extend self

    # Public: Handles the calling of a API method (instance and class scope).
    #
    # klass     - The class or instance of the class containing the API method
    # options   - A options Hash to refine required values
    #             :lookup_tbl   - The class lookup table instance.
    #             :scope        - The scope the API method should be called on.
    #             :method_name  - The API method's name
    # *args     - argument list of the API method
    # &block    - An optional block passed to the API method
    #
    # Returns the return value of the API methods implementation method if
    # the method configuration was found at the lookup table.
    def handle(klass, options, *args, &block)
      lookup_tbl  = options[:lookup_tbl]
      scope       = options[:scope]
      method_name = options[:method_name]

      api_method_config = lookup_tbl.
                          find_method(method_name, scope: scope)
      arity = api_method_config[method_name][:arity]
      if api_method_config[method_name][:block_required]
        if block.nil?
          raise Seatbelt::Errors::ApiMethodBlockRequiredError
        end
      end
      Seatbelt::Terminal.call(method_name, klass, arity, *args, &block)
    end
  end
end
