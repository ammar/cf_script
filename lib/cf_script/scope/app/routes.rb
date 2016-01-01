module CfScript::Scope
  module App::Routes
    def has_route?(domain, host = nil)
      route = [host, domain].compact.join('.')

      urls.split(', ').include?(route)
    end

    def map_route(domain, host =  nil)
      CfScript::Command.map_route name, domain, host do |mapped|
        cf_self; has_route?(domain, host)
      end
    end

    def unmap_route(domain, host =  nil)
      CfScript::Command.unmap_route name, domain, host do |unmapped|
        cf_self; not has_route?(domain, host)
      end
    end
  end
end
