module Seatbelt

  # Public: Various errors used with Seatbelt.
  #
  module Errors

    # Public: Will be raised if there are too much or too few arguments passed
    # to a method.
    # Only declared for design purposes.
    #
    class ArgumentsMissmatchError < ::ArgumentError; end


    # Public: Will be raised within Seatbelt::Pool::Api#api_method if no meta
    # method name is passed.
    #
    class MissingMetaMethodName < ::StandardError
      def message
        "You have to specifiy a meta-method name!"
      end
    end


    # Public: Will be raised if a meta method definition will be inserted into
    # the class lookuptable but already exists.
    #
    class MetaMethodDuplicateError < ::StandardError
      def message
        "The meta-method you want to define is ambigious."
      end
    end


    # Public: Will be raised if a meta method is defined but not implemented in
    # the remote class.
    #
    class MethodNotImplementedError < ::NoMethodError; end


    # Public: Will be raised if a method directive for configurating the Gate is
    # used but the directive is not allowed for usage.
    #
    class DirectiveNotAllowedError < ::StandardError
      def message
        "The directive you want to use is not allowed."
      end
    end


    # Public: Will be raised if a method isn't implemented at a class or class
    # instance.
    #
    class NoMethodError < MethodNotImplementedError; end


    # Public: Will be raised if a method requires a block but isn't passed to
    # the method.
    #
    class ApiMethodBlockRequiredError < ::StandardError
      def message
        "The method you want to call requires a block."
      end
    end

  end
end