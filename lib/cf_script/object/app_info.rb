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
    @requested_state = attrs[:requested_state].value if attrs.key?(:requested_state)
    @instances       = attrs[:instances].value if attrs.key?(:instances)

    @urls            = attrs.key?(:urls) ? attrs[:urls].to_a : []

    @usage           = attrs[:usage].value if attrs.key?(:usage)
    @last_uploaded   = attrs[:last_uploaded].value if attrs.key?(:last_uploaded)
    @stack           = attrs[:stack].value if attrs.key?(:stack)
    @buildpack       = attrs[:buildpack].value if attrs.key?(:buildpack)

    @memory          = attrs[:memory].value if attrs.key?(:memory)
    @disk            = attrs[:disk].value if attrs.key?(:disk)

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
