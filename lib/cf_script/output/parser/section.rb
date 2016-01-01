module CfScript
  module Output::Parser::Section
    def extract_section(buffer, header)
      if match = buffer.match(/^#{header}:?\s*\n(.*?)\n\n/m)
        match[1]
      end
    end

    def parse_section_attributes(buffer, header)
      if section = extract_section(buffer, header)
        parse_attribute_list(section, false)
      end
    end
  end
end
