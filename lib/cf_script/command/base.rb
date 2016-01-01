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

    def can_run?(output, options = {})
      options[:check_status] = options.key?(:check_status) ? options[:check_status] : true
      options[:check_failed] = options.key?(:check_failed) ? options[:check_failed] : true

      if options[:check_status] == true && !output.good?
        error 'cf exited with error'
        output.dump
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
        output.dump
        return false
      end

      true
    end
  end
end
