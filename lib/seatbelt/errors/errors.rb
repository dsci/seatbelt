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

    # Public: Will be raised if a model is assigned to a 'has_many' association
    # and the models class isn't of required type.
    class TypeMissmatchError < ::StandardError
      attr_accessor :awaited, :got

      # Public: Initialize a TypeMissmatchError.
      #
      # awaited - The awaited objects class name
      # got     - The actual assigned objects class name.
      def initialize(awaited, got)
        @awaited = awaited
        @got = got
      end

      # The exception message in an understandable form.
      #
      # Returns the error message.
      def to_s
        msg = "An instance of #{awaited} awaited but "
        msg += "get an instance of #{got}."
        return msg
      end
    end

    # Public: Will be raised if a question/query is called and no tape with
    # implementation is found.
    #
    class NoTapeFoundForQueryError < ::StandardError
      def message
        "There is no tape implemented for answering this question."
      end
    end

    # Public: Will be raised if a tape should be used in multiple tape decks.
    #
    class MultipleTapeUsageDetectedError < ::StandardError
      def message
        "A tape can't be used in multiple tape decks."
      end
    end

    # Public: Will be raised if a synthseizer did not implement the
    # synthesizable_attributes method.
    class SynthesizeableAttributesNotImplementedError < ::StandardError
      def message
        "Your synthesizer has to implement #synthesizable_attributes."
      end
    end

    # Public: Will be raised if an object is tried to call that does not exist
    # at runtime.
    class ObjectDoesNotExistError < ::StandardError
      def message
        "The object you called does not exist."
      end
    end

    class ArgumentMissmatchError < ArgumentError; end

    # Public: Will be raised if a property is tried to define on a class level
    # interface.
    class PropertyOnClassLevelDefinedError < ::StandardError
      def message
        <<-MESSAGE.gsub(/^\s+/, "")
          You try to define a property at class level interface. That is not
            supported by now but maybe in future version.
        MESSAGE
      end
    end

    class PropertyNotDefinedYetError < ::StandardError

      def initialize(property_name)
        @property_name = property_name
      end

      def to_s
        <<-MESSAGE.gsub(/^\s+/, "")
          You try to define a property as accessible that is not defined yet.
          Use define_property :#{@property_name} to define your property first.
        MESSAGE
      end
    end

  end
end
