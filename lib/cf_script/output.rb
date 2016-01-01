CfScript.const_set(:Output, Class.new)

require 'cf_script/output/buffer'
require 'cf_script/output/parser'
require 'cf_script/output/tests'
require 'cf_script/output/utils'

module CfScript
  class Output
    attr_reader :command
    attr_reader :stdout
    attr_reader :stderr
    attr_reader :status

    include CfScript::Output::Parser
    include CfScript::Output::Tests
    include CfScript::Output::Utils

    def initialize(command, stdout, stderr, status)
      @command = command
      @stdout  = stdout
      @stderr  = stderr
      @status  = status
    end

    def good?
      status.success? && status.exitstatus == 0
    end

    def out
      @sane_stdout ||= Buffer.new(stdout)
    end

    def err
      @sane_stderr ||= Buffer.new(stderr)
    end

    def last_line
      out.last_line
    end

    def attributes
      parse_attribute_list(out)
    end

    def line_attributes(line_regexp)
      parse_line_attributes(out, line_regexp)
    end

    def attributes_from(line_start)
      parse_attribute_list(out.from(line_start))
    end

    def table(headers)
      parse_table(out, headers)
    end

    def section_attributes(header)
      parse_section_attributes(out, header)
    end
  end
end
