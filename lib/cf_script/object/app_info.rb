class CfScript::AppInfo
  # These are always available
  attr_reader :name
  attr_reader :requested_state
  attr_reader :instances
  attr_reader :urls

  # These are available from `cf app` only
  attr_reader :usage
  attr_reader :last_uploaded
  attr_reader :stack
  attr_reader :buildpack

  # These are available from `cf apps` only
  attr_reader :memory # patched from :usage
  attr_reader :disk

  # This gets set after some commands, like push and start
  attr_reader :instance_status

  def initialize(name, attrs)
    @name = name

    update(attrs)
  end

  def state
    requested_state
  end

  def started?
    state == 'started'
  end

  alias :hot? :started?

  def stopped?
    state == 'stopped'
  end

  alias :cold? :stopped?

  def update(attrs)
    @requested_state = attrs.key?(:requested_state) ? attrs[:requested_state].value : nil
    @instances       = attrs.key?(:instances) ? attrs[:instances].value : nil

    @urls            = attrs.key?(:urls) ? attrs[:urls].to_a : []

    @usage           = attrs.key?(:usage) ? attrs[:usage].value : nil
    @last_uploaded   = attrs.key?(:last_uploaded) ? attrs[:last_uploaded].value : nil
    @stack           = attrs.key?(:stack) ? attrs[:stack].value : nil
    @buildpack       = attrs.key?(:buildpack) ? attrs[:buildpack].value : nil

    @memory          = attrs.key?(:memory) ? attrs[:memory].value : nil
    @disk            = attrs.key?(:disk) ? attrs[:disk].value :  nil

    if @memory.nil? and @usage
      @memory = @usage.split(' ').first
    end
  end

  def set_instance_status(instance_statuses)
    @instance_status = []

    instance_statuses.each do |instance_status|
      @instance_status << CfScript::InstanceStatus.new(instance_status)
    end
  end
end
