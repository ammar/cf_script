CfScript::Command.const_set(:Spaces, Module.new)

require 'cf_script/command/cf/spaces/spaces'
require 'cf_script/command/cf/spaces/space'

module CfScript::Command::Spaces
  CfScript::Command.register SpacesCommand
  CfScript::Command.register SpaceCommand
end
