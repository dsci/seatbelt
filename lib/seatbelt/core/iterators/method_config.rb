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
        def self.array_method_iterator(klass, gate_klass, scope)
          return lambda do |method_config|
            method_config.send(:each_pair,
                               &hash_method_iterator(klass,gate_klass, scope))
          end
        end


        # Public: Method config iterator block used by Gate#implement_class.
        #
        # klass       - The API class name
        # gate_klass  - The class that includes the Gate module
        #
        # Returns a Proc that is useable for {}.each_pair
        def self.hash_method_iterator(klass, gate_klass, scope)
          methods_bucket = :implementation_methods if scope.eql?(:instance)
          methods_bucket = :implementation_class_methods if scope.eql?(:class)
          return lambda do |(key,value)|
            method_name = key
            implementation_config = {}
            implementation_config[method_name] = {
              :as => "#{klass}#{value[:as]}",
            }
            if value[:delegated]
              implementation_config[method_name][:delegated] = value[:delegated]
            end
            gate_klass.send(methods_bucket) << implementation_config
          end
        end

      end
    end
  end
end
