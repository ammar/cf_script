require 'set'

module CfScript
  class Scope::Proxy
    BASIC_OBJECT_METHODS = BasicObject.instance_methods.to_set
    PROXY_OBJECT_METHODS = BASIC_OBJECT_METHODS | Set[
      :object_id,
      :instance_variables,
      :instance_variable_get,
      :instance_variable_set
    ]

    PROXY_OBJECT_INSTANCE_VARIABLES = Set[:@__inner__, :@__outer__]

    instance_methods.each do |m|
      undef_method(m) unless PROXY_OBJECT_METHODS.include?(m)
    end

    def initialize(inner, outer)
      @__inner__ = inner
      @__outer__ = outer
    end

    def instance_variables
      super.select { |v| !PROXY_OBJECT_INSTANCE_VARIABLES.include?(v.to_sym) }
    end

    def method_missing(m, *args, &block)
      if @__inner__.respond_to?(m.to_sym)
        @__inner__.__send__(m.to_sym, *args, &block)
      else
        @__outer__.__send__(m.to_sym, *args, &block)
      end
    end
  end
end
