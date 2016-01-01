CfScript::Command.const_set(:General, Module.new)

require 'cf_script/command/cf/general/api'
require 'cf_script/command/cf/general/auth'
require 'cf_script/command/cf/general/login'
require 'cf_script/command/cf/general/logout'
require 'cf_script/command/cf/general/target'

module CfScript::Command::General
  CfScript::Command.register ApiCommand
  CfScript::Command.register AuthCommand
  CfScript::Command.register LoginCommand
  CfScript::Command.register LogoutCommand
  CfScript::Command.register TargetCommand
end
