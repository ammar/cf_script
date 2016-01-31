require 'singleton'

module CfScript::Command
  class Base
    include ::Singleton

    attr_reader :type
    attr_reader :name

    include CfScript::Command::Runner

    include CfScript::UI
    include CfScript::UI::NameTag

    def initialize(type, name)
      @type = type
      @name = name
    end

    def line(env, bin, args)
      Line.new(env, bin, type, name, args)
    end

    def run(*args, &block)
      raise "run called in base command class"
    end

    def option_value(options, key, default)
      options.key?(key) ? options[key] : default
    end

    def good_run?(output, options = {})
      options[:check_status] = option_value(options, :check_status, true)
      options[:check_failed] = option_value(options, :check_failed, true)

      if options[:check_status] == true && !output.good?
        error 'cf exited with error'
        output.dump unless CfScript.config.runtime.echo_output
        return false
      end

      if output.no_api_endpoint?
        error "No API endpoint set"
        return false
      end

      if output.not_logged_in?
        error 'Not logged in'
        return false
      end

      if options[:check_failed] == true && output.failed?
        error 'FAILED'
        output.dump unless CfScript.config.runtime.echo_output
        return false
      end

      true
    end
  end
end
