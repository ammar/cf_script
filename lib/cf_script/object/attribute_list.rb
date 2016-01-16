class CfScript::AttributeList
  extend Forwardable
  include Enumerable

  def_delegators :@list, :[], :key?, :empty?, :length, :clear, :each

  def initialize(attributes = [])
    @list = {}

    attributes.each do |attribute|
      self << attribute
    end
  end

  def names
    @list.keys
  end

  def values
    @list.values.map { |attr| attr.value }
  end

  def <<(attr)
    if @list.key?(attr.name)
      raise "Duplicate attribute '#{attr.name}'"
    end

    @list[attr.name] = attr
  end

  def to_h
    hash = {}

    @list.each do |name, attr|
      hash[name] = attr.value
    end

    hash
  end
end
