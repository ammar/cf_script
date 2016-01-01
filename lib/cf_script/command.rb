module CfScript::Command
  # TODO: decide which is better, @_registry or @@_registry
  class << self
    attr_reader :_registry
  end

  extend CfScript::UI

  module_function

  def registry
    @_registry ||= Registry.new
  end

  def register(command_class)
    registry.add!(command_class)
  end

  def run(command_name, *args, &block)
    registry.check!(command_name)

    begin
      registry[command_name].run(*args, &block)
    rescue StandardError => e
      error command_name, e.message
    end
  end

  def method_missing(m, *args, &block)
    run(m, *args, &block)
  end
end

require 'cf_script/command/registry'
require 'cf_script/command/runner'

require 'cf_script/command/base'
require 'cf_script/command/error'
require 'cf_script/command/line'

require 'cf_script/command/cf/general'
require 'cf_script/command/cf/apps'
require 'cf_script/command/cf/spaces'
require 'cf_script/command/cf/routes'
