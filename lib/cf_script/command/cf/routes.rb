CfScript::Command.const_set(:Routes, Module.new)

require 'cf_script/command/cf/routes/routes'
require 'cf_script/command/cf/routes/check_route'
require 'cf_script/command/cf/routes/create_route'
require 'cf_script/command/cf/routes/delete_route'
require 'cf_script/command/cf/routes/map_route'
require 'cf_script/command/cf/routes/unmap_route'

module CfScript::Command::Routes
  CfScript::Command.register RoutesCommand
  CfScript::Command.register CheckRouteCommand
  CfScript::Command.register CreateRouteCommand
  CfScript::Command.register DeleteRouteCommand
  CfScript::Command.register MapRouteCommand
  CfScript::Command.register UnmapRouteCommand
end
