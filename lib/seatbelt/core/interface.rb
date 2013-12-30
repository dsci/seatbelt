module Seatbelt
  module Interface
    extend self
    include Seatbelt::Property::ClassMethods
    # Public: Provides definitions of API Meta methods. For more informations
    # of API meta methods see Seatbelt::Pool::Api#api_method
    #
    # scope     - the type the methods should be defined for [:instance, :class]
    #
    # &block    - The block that contains the API method definitions.
    #
    # Example
    #
    #   class Hotel
    #     include Seatbelt::Ghost
    #
    #     interface :class do
    #       define  :find_nearby,
    #               :block_required => false,
    #               :args => [:options]
    #     end
    #   end
    #
    def interface(scope, &block)
      @scope = scope
      yield(self) if block
    end

    # Public: Defines an API method. This is only working if its called within
    # the #interface method block.
    #
    # Wraps Seatbelt::Pool::Api#api_method
    #
    # name        - Name of the API method
    # hsh         - an options Hash that refines the methods usage:
    #               :scope           - the method type
    #                                  [:instance, :class]
    #                                  defaults to :instance
    #               :block_required  - defines if the method
    #                                  require a Ruby Block for
    #                                  usage.
    #               :args             - An array of expected
    #                                   arguments as Symbols or
    #                                   Strings. If omitted the
    #                                   method expects no arguments.
    def define(name, hsh={})
      hsh[:scope] = @scope
      self.send(:api_method, name, hsh)
    end
  end
end