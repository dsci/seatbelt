module Seatbelt

  # Public: Lookup table implementation that holds all meta methods for a
  # Seatbelt API Class.
  #
  class LookupTable < Array

    alias_method :add_method, :<<
    alias_method :set, :<<

    # Public: Removes a method configuration from the lookup table.
    #
    # method_name - The method name identifier as Symbol.
    # scope       - The scope in for removing the method, defaults to :instance
    #
    # Returns the removed method configuration if found otherwise nil.
    def remove_method(method_name, scope: :instance)
      method = find_method(method_name, scope: scope)
      delete(method) if method
    end
    alias_method :unset, :remove_method


    # Public: Finds a method configuration by method name.
    #
    # method_name - The method configuration identifier.
    # scope       - The scope to search for the method, defaults to :instance
    #
    # Example:
    #
    # table = Seatbelt::LookupTable.new
    # table.set({:my_method => {:scope => :klass, :block_required => true } })
    #
    # method = table.find_method(:my_method)
    # #=> {:my_method => {:scope => :klass, :block_required => true } }
    #
    # Returns the method configuration if found, otherwise nil.
    def find_method(method_name, scope: :instance)
      detect do |method_config|
        name          = method_config.keys.first
        method_scope  = method_config[name][:scope]
        name.eql?(method_name.to_sym) && method_scope.eql?(scope)
      end
    end


    # Public: Gets a method configuration by name or configuration.
    #
    # method_c - The method identifier or its whole configurations Hash
    # scope    - The scope to search for the method, defaults to :instance
    #
    # Example:
    #
    # table     = Seatbelt::LookupTable.new
    # config    = {
    #   :my_method => {
    #     :scope          => :klass,
    #     :block_required => true
    #   }
    # }
    # table.set(config)
    #
    # method = table.get(:my_method)
    # #=> {:my_method => {:scope => :klass, :block_required => true } }
    #
    # method = table.get(config)
    # #=> {:my_method => {:scope => :klass, :block_required => true } }
    #
    # Returns the method configuration if found, otherwise nil.
    def get(method_c, scope: :instance)
      eqlCheck = false
      identifier = if method_c.is_a?(Symbol) or method_c.is_a?(String) then
        method_c
      elsif method_c.is_a?(Hash)
        scope     = method_c.values.first[:scope]
        eqlCheck  = true
        method_c.keys.first
      end
      method = find_method(identifier, scope: scope)

      return method unless eqlCheck
      return method if method.eql?(method_c)
    end


    # Public: Check if the lookup table contains a method configuration.
    #
    # identifier - The method configuration identifier or the configuration
    # scope      - The scope to search for the method, defaults to :instance
    #
    # Returns true if table has method otherwise false.
    def has?(identifier, scope: :instance)
      if identifier.is_a?(Symbol) or identifier.is_a?(String)
        return not(find_method(identifier, scope: scope).nil?)
      elsif identifier.is_a?(Hash)
        return not(get(identifier, scope: scope).nil?)
      end
    end

  end
end
