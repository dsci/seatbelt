module Seatbelt

  # Public: Various errors used with Seatbelt.
  #
  module Errors

    # Public: Will be raised if there are too much or too few arguments passed
    # to a method.
    # Only declared for design purposes.
    #
    class ArgumentsMissmatchError < ArgumentError; end


    # Public: Will be raised within Seatbelt::Pool::Api#api_method if no meta
    # method name is passed.
    #
    class MissingMetaMethodName < StandardError
      def message
        "You have to specifiy a meta-method name!"
      end
    end


    # Public: Various methods useful for performing mathematical operations.
    # All methods are module methods and should be called on the Math module.
    #
    class MetaMethodDuplicateError < StandardError
      def message
        "The meta-method you want to define is ambigious."
      end
    end

  end
end