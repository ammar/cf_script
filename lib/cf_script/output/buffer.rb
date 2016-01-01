module CfScript
  class Output::Buffer
    attr_reader :raw

    ANSI_ESCAPE_SEQUENCE_REGEXP = /\e\[(\d+)(;\d+)*m/

    def initialize(buffer = nil)
      @raw = buffer
    end

    def content
      @clean_content ||= sanitize
    end

    def lines
      @clean_lines ||= sanitize_lines
    end

    def last_line
      lines.last
    end

    def [](arg)
      content[arg]
    end

    def each_line(&block)
      content.each_line(&block)
    end

    def from(pattern)
      lines_from(pattern).join("\n")
    end

    def lines_from(pattern)
      index = lines.find_index { |line| line =~ /#{pattern}/ }
      index ? lines[index..-1] : []
    end

    def match(regexp)
      content.match(regexp)
    end

    def matches?(regexp)
      content =~ regexp ? true : false
    end

    def contains?(text)
      matches? /#{text}/
    end

    def last_line_matches?(regexp)
      last_line =~ regexp ? true : false
    end

    private

    def sanitize
      raw.gsub ANSI_ESCAPE_SEQUENCE_REGEXP, ''
    end

    def sanitize_line(line)
      line.gsub! ANSI_ESCAPE_SEQUENCE_REGEXP, ''
      line.strip!
      line
    end

    def sanitize_lines
      raw.lines.map! do |line|
        sanitize_line(line)
      end
    end
  end
end
