class CfScript::AppSpec < CfScript::Object
  include CfScript::Callbacks
  include CfScript::UI

  def initialize(spec)
    @org       = spec[:org]
    @env       = spec[:env]
    @domain    = spec[:domain]
    @name      = spec[:name]
    @type      = spec[:type]
    @phase     = spec[:phase]
    @memory    = spec[:memory] || '2GB'
    @instances = spec[:instances] || 1
  end

  def push_options
    {
     #domain:             @domain,
     #hostname:           hostname,
      memory:             @memory,
      instances:          @instances,
      health_check_type:  @health_check,
      flags: [
        :no_route,
        :no_start,
        :no_manifest,
      ]
    }
  end

  def method_missing(m, *args, &block)
    if args.empty? && block.nil?
      instance_variable_get("@#{m}")
    elsif !args.empty? && block.nil?
      instance_variable_set("@#{m}", args.first)
    elsif args.empty? && !block.nil?
      instance_variable_set("@#{m}", yield)
    else
      raise "Can not accept arguments and a block. " +
            "Pass arguments or a block, not both."
    end
  end

  def full_name
    [name, type, phase].compact.join('-')
  end

  def hostname
    [org, env, name, type, phase].compact.join('-')
  end

  def fqdn
    [hostname, domain].compact.join('.')
  end
end
