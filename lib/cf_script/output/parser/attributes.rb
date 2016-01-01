module CfScript
  module Output::Parser::Attributes
    ATTRIBUTE_REGEXP = /^(?<name>[^:]+):\s+(?<value>.+)$/

    def parse_attribute(line, symbolize_name = false)
      if line =~ ATTRIBUTE_REGEXP
        name  = Regexp.last_match[:name].strip
        value = Regexp.last_match[:value].strip

        CfScript::Attribute.new(
          symbolize_name ? symbolize(name) : name,
          Regexp.last_match['value'].strip
        )
      end
    end

    def parse_attribute_list(buffer, symbolize_names = true)
      attribute_list = CfScript::AttributeList.new

      buffer.each_line do |line|
        if attribute = parse_attribute(line, symbolize_names)
          attribute_list << attribute
        end
      end

      attribute_list
    end

    def parse_line_attributes(buffer, regexp)
      if matched = buffer.match(regexp)
        attribute_list = CfScript::AttributeList.new

        matched.names.each do |name|
          attribute_list << CfScript::Attribute.new(
            symbolize(name),
            matched[name].strip
          )
        end

        attribute_list
      end
    end
  end
end
