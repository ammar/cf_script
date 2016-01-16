class CfScript::InstanceStatus
  attr_reader :index
  attr_reader :state
  attr_reader :since
  attr_reader :cpu
  attr_reader :memory
  attr_reader :disk
  attr_reader :details

  def initialize(attrs = {})
    @index   = attrs[:index]   ? attrs[:index].value   : nil
    @state   = attrs[:state]   ? attrs[:state].value   : nil
    @since   = attrs[:since]   ? attrs[:since].value   : nil
    @cpu     = attrs[:cpu]     ? attrs[:cpu].value     : nil
    @memory  = attrs[:memory]  ? attrs[:memory].value  : nil
    @disk    = attrs[:disk]    ? attrs[:disk].value    : nil
    @details = attrs[:details] ? attrs[:details].value : nil
  end

  def show(*attrs)
    line = []

    attrs.each do |attr|
      line << "#{attr}: #{send(attr)}"
    end

    line.join(', ')
  end
end
