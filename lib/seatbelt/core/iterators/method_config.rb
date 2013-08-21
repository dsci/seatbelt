module Seatbelt
  module Core
    module Iterators

      # Public: Various methods useful for performing mathematical operations.
      # All methods are module methods and should be called on the Math module.
      #
      class MethodConfig


        # Public: Method config iterator block used by Gate#implement_class.
        #
        # klass       - The API class name
        # gate_klass  - The class that includes the Gate module
        #
        # Returns a Proc that is useable for [].each
        def self.array_method_iterator(klass, gate_klass)
          return lambda do |method_config|
            method_config.send(:each_pair,
                               &hash_method_iterator(klass,gate_klass))
          end
        end


        # Public: Method config iterator block used by Gate#implement_class.
        #
        # klass       - The API class name
        # gate_klass  - The class that includes the Gate module
        #
        # Returns a Proc that is useable for {}.each_pair
        def self.hash_method_iterator(klass, gate_klass)
          return lambda do |(key,value)|
            method_name = key
            implementation_config = {}
            implementation_config[method_name] = {
              :as => "#{klass}#{value[:as]}",
            }
            gate_klass.send(:implementation_methods) << implementation_config
          end
        end

      end
    end
  end
end