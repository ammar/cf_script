module CfScript::Command::Routes
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
