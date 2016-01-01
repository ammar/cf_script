CfScript::Output.const_set(:Parser, Module.new)

require 'cf_script/output/parser/attributes'
require 'cf_script/output/parser/section'
require 'cf_script/output/parser/table'

module CfScript
  module Output::Parser
    include CfScript::Utils

    include CfScript::Output::Parser::Attributes
    include CfScript::Output::Parser::Section
    include CfScript::Output::Parser::Table
  end
end
