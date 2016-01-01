CfScript::Command.const_set(:Routes, Module.new)

#require 'cf_script/command/cf/routes/routes'
require 'cf_script/command/cf/routes/check_route'
#require 'cf_script/command/cf/routes/create_route'
#require 'cf_script/command/cf/routes/delete_route'
require 'cf_script/command/cf/routes/map_route'
#require 'cf_script/command/cf/routes/unmap_route'

module CfScript::Command::Routes
 #CfScript::Command.register RoutesCommand
  CfScript::Command.register CheckRouteCommand
 # CfScript::Command.register CreateRouteCommand
 # CfScript::Command.register DeleteRouteCommand
  CfScript::Command.register MapRouteCommand
 # CfScript::Command.register UnmapRouteCommand

# def map_route(app, domain, host =  nil, &block)
#   options = host ? { n: host } : {}

#   run_cf :map_route, app_name(app), domain, options do |output|
#     mapped = output.ok?

#     block_given? ? yield(mapped) : mapped
#   end
# end

# def unmap_route(app, domain, host =  nil, &block)
#   options = host ? { n: host } : {}

#   run_cf :unmap_route, app_name(app), domain, options do |output|
#     unmapped = output.ok?

#     block_given? ? yield(unmapped) : unmapped
#   end
# end

# def check_route(host, domain, &block)
#   run_cf :check_route, host, domain do |output|
#     exists = output.last_out =~ /^Route #{host}.#{domain} does exist/

#     block_given? ? yield(exists) : exists
#   end
# end

# def delete_route(domain, host = nil, flags = {}, &block)
#   options = host ? { n: host } : {}

#   # f: nil because -f is a flag (doesn't take a value)
#   options.merge!(f: nil) if flags[:force]

#   run_cf :delete_route, domain, options do |output|
#     deleted = output.ok?

#     block_given? ? yield(deleted) : deleted
#   end
# end
end
