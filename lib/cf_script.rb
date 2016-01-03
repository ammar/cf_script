require_relative './cf_script/version'
require_relative './cf_script/config'
require_relative './cf_script/utils'
require_relative './cf_script/ui'
require_relative './cf_script/output'
require_relative './cf_script/executor'
require_relative './cf_script/scope'
require_relative './cf_script/command'
require_relative './cf_script/object'
require_relative './cf_script/manifest'

module CfScript
  class << self
    attr_accessor :configuration

    attr_accessor :definitions

    attr_accessor :cf_call_count
    attr_accessor :cf_call_stack
  end

  extend CfScript::Scope::Execution
  extend CfScript::UI

  module_function

  def config
    @configuration ||= Config.new
  end

  def configure
    block_given? ? yield(config) : config
  end

  def stdout
    config.io.stdout
  end

  def stderr
    config.io.stderr
  end

  def manifest(path = nil)
    @manifest ||= CfScript::Manifest.new(path)
  end

  def define(app_name, &block)
    @definitions ||= {}
    @definitions[app_name] = AppSpec.new(name: app_name).tap do |spec|
      spec.instance_exec(&block)
    end
  end

  def spec_for(app_name)
    @definitions ||= {}
    @definitions[app_name]
  end

  def cf(options = {}, &block)
    @cf_call_count ||= 0
    @cf_call_stack ||= []

    if @cf_call_count == 0
      info :cf, CfScript::Command::Runner.cf_id
    end

    @cf_call_count += 1
    @cf_call_stack.push CfScript::Scope::Script.new(options)
    @cf_call_stack.last.run(&block)
  rescue StandardError => e
    print_error(e)
  ensure
    @cf_call_stack.last.finalize if @cf_call_stack.last
    @cf_call_stack.pop
  end

  def stack_level
    @cf_call_stack.length - 1
  end

  def print_error(e)
    error "cf:#{stack_level}", e.message
    e.backtrace.each do |line|
      error "cf:#{stack_level}", line
    end

    if stdout.is_a?(StringIO)
      STDOUT.puts "cf:#{stack_level} #{e.message}"
      e.backtrace.each do |line|
        STDOUT.puts "cf:#{stack_level} #{line}"
      end
    end
  end

  class << self
    private :stack_level
    private :print_error
  end
end

def cf(options = {}, &block)
  CfScript.cf(options, &block)
end
