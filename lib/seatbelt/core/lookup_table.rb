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
    #
    # Returns the removed method configuration if found otherwise nil.
    def remove_method(method_name)
      method = find_method(method_name)
      if method
        delete(method)
      end
    end
    alias_method :unset, :remove_method


    # Public: Finds a method configuration by method name.
    # 
    # method_name - The method configuration identifier.
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
    def find_method(method_name)
      detect{ |m| m.keys.first.eql?(method_name.to_sym) }
    end


    # Public: Gets a method configuration by name or configuration.
    #
    # method_c - The method identifier or its whole configurations Hash
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
    def get(method_c)
      if method_c.is_a?(Symbol) or method_c.is_a?(String)
        method = find_method(method_c)
      elsif method_c.is_a?(Hash)
        method = find_method(method_c.keys.first)
        return method if method.eql?(method_c)
      end
    end


    # Public: Check if the lookup table contains a method configuration.
    #
    # identifier - The method configuration identifier or the configuration
    #
    # Returns true if table has method otherwise false.
    def has?(identifier)
      if identifier.is_a?(Symbol) or identifier.is_a?(String)
        return not(find_method(identifier).nil?)
      elsif identifier.is_a?(Hash)
        return not(get(identifier).nil?)
      end
    end

  end
end
