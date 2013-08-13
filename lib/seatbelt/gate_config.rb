module Seatbelt
  
  # Public: A configuration class to configure the Gate.
  #
  class GateConfig

    # Public: Setter to set the instance method directive. This is optional
    # and defaults to #
    #
    # :: is not allowed as directive.
    #
    # directive - A String representing the directive.
    #
    def self.method_directive_instance=(directive)
      Seatbelt.check_directive(directive)
      @method_directive_instance = directive
    end

    # Public: Setter to set the class method directive. This is optional
    # and defaults to .
    #
    # :: is not allowed as directive.
    #
    # directive - A String representing the directive.
    #
    def self.method_directive_class=(directive)
      Seatbelt.check_directive(directive)
      @method_directive_class = directive
    end

    # Public: Getter to retrieve te instance method directive.
    #
    # Returns the instance method directive if set otherwise '#'
    def self.method_directive_instance
      @method_directive_instance || "#"
    end

    # Public: Getter to retrieve te class method directive.
    #
    # Returns the class method directive if set otherwise '.'
    def self.method_directive_class
      @method_directive_class || "."
    end

    # Public: Hash of method directives attached to its scope.
    #
    # Contains :class and :instance keys and their corrosponding method
    # directives
    #
    # Returns a Hash.
    def self.method_directives
      {
        :class    => self.method_directive_class,
        :instance => self.method_directive_instance
      }
    end

  end
end
