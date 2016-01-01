module CfScript::Scope
  module Execution
    module_function

    def exec_in(inner, *args, &block)
      outer = eval('self', block.binding)
      outer = CfScript::Scope::Root.new if outer.class == Object

      inner_proxy = CfScript::Scope::Proxy.new(inner, outer)

      begin
        outer.instance_variables.each do |var|
          val = outer.instance_variable_get(var)
          inner_proxy.instance_variable_set(var, val)
        end

        inner_proxy.instance_exec(*args, &block)
      ensure
        outer.instance_variables.each do |var|
          val = inner_proxy.instance_variable_get(var)
          outer.instance_variable_set(var, val)
        end
      end
    end
  end

  class Base
    include Execution
    include CfScript::UI

    def initialize
      enter_scope
    end

    def finalize
      exit_scope
    end

    def spec_for(name)
      CfScript.spec_for(name)
    end

    def method_missing(m, *args, &block)
      CfScript::Command.run(m, *args, &block)
    end

    protected

    def scope_name
      self.class.name.split('::').last.downcase
    end

    def enter_scope
    end

    def exit_scope
    end
  end

  class Root < Base
  end
end

require 'cf_script/scope/proxy'
require 'cf_script/scope/target'
require 'cf_script/scope/script'
require 'cf_script/scope/space'
require 'cf_script/scope/app'
