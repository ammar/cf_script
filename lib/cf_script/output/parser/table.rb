module CfScript
  module Output::Parser::Table
    def parse_columns(line)
      line ? line.split(/\s{2,}/).map(&:strip) : []
    end

    def parse_row(line, columns)
      row    = CfScript::AttributeList.new
      values = line.split(/\s{2,}/, columns.length).map!(&:strip)

      columns.each_with_index do |column, index|
        # Special case for instance status tables
        name = index == 0 && column == '' ? 'index' : column

        row << CfScript::Attribute.new(
          symbolize(name),
          (values[index] ? values[index].strip : '')
        )
      end

      row
    end

    def parse_rows(lines)
      rows = []

      if lines.first.strip.empty?
        lines.shift
      end

      cols = parse_columns(lines.shift)

      lines.each do |line|
        rows << parse_row(line, cols)
      end

      rows
    end

    def parse_table(buffer, headers)
      if m = buffer.match(/^#{headers.join('\s+')}/)
        parse_rows buffer[m.begin(0)..-1].lines
      end
    end
  end
end
