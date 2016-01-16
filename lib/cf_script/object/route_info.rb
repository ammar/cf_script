class CfScript::RouteInfo
  attr_reader :space
  attr_reader :host
  attr_reader :domain
  attr_reader :apps

  def initialize(space = nil, host = nil, domain = nil, apps = [])
    @space  = space
    @host   = host
    @domain = domain
    @apps   = apps
  end
end

