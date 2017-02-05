module ObjectHelpers
  def build_attribute_list(attrs = {})
    list = CfScript::AttributeList.new()

    attrs.each do |name, value|
      list << CfScript::Attribute.new(name, value)
    end

    list
  end

  def build_instance_status_attrs(options = {})
    build_attribute_list({
      index:    '0',
      state:    '1',
      since:    '2',
      cpu:      '3',
      memory:   '4',
      disk:     '5',
      details:  '6'
    }.merge(options))
  end

  def build_instance_status(options = {})
    attrs = build_instance_status_attrs(options)

    CfScript::InstanceStatus.new(attrs)
  end
end
