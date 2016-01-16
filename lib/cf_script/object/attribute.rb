class CfScript::Attribute
  attr_reader :name, :value

  def initialize(name, value)
    @name  = name
    @value = value
  end

  def to_a
    value ? value.split(/,\s*/) : []
  end

  def to_s
    "#{name}: #{value}"
  end

  alias :inspect :to_s
end
