class CfScript::Space
  attr_reader :name
  attr_reader :org
  attr_reader :apps
  attr_reader :domains
  attr_reader :services
  attr_reader :security_groups

  def initialize(name, org = nil, apps = [], domains = [], services = [], security_groups = [])
    @name            = name
    @org             = org
    @apps            = apps
    @domains         = domains
    @services        = services
    @security_groups = security_groups
  end
end
