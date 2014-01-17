require "seatbelt/dependencies"
require "seatbelt/version"
require "seatbelt/seatbelt"

module Seatbelt

  METHOD_EXCLUDE_DIRECTIVES = %w{ :: }

  # Internal: Checks a directive if allowed. Raises a DirectiveNotAllowedError
  # if directive is not allowed.
  #
  # directive - the directive String to check.
  #
  # Returns nothing
  def self.check_directive(directive)
    if directive.in?(METHOD_EXCLUDE_DIRECTIVES)
      raise Seatbelt::Errors::DirectiveNotAllowedError
    end
  end


  # Public: Configures the Gate. Needs a block.
  #
  # Example:
  #
  #   Seatbelt.configure_gate do |config|
  #     config.method_directive_instance  = "|"
  #     config.method_directive_class     = "~"
  #   end
  #
  # Returns nothing.
  def self.configure_gate
    yield GateConfig if block_given?
  end

end

