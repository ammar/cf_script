require 'test_helper'

describe CfScript::Output::Buffer do
  attr_accessor :buffer
  attr_accessor :raw_text

  def setup
    @raw_text = "\e[4;31;42mline 1\e[0m\n" +
                "\e[4;32;44mline 2\e[0m\n" +
                "\e[4;34;41mline 3\e[0m\n"

    @buffer = CfScript::Output::Buffer.new(@raw_text)
  end

  it "responds to raw and returns a original text" do
    assert buffer.respond_to?(:raw), "Expected Buffer to respond to raw"
    assert_equal raw_text, buffer.raw
  end

  it "responds to content and returns a sanitized copy" do
    assert buffer.respond_to?(:content), "Expected Buffer to respond to content"
    assert_equal "line 1\nline 2\nline 3\n", buffer.content
  end

  it "responds to lines and returns sanitized lines" do
    assert buffer.respond_to?(:lines), "Expected Buffer to respond to lines"
    assert_equal ['line 1', 'line 2', 'line 3'], buffer.lines
  end

  it "responds to last_line and returns last line content" do
    assert_equal 'line 3', buffer.last_line
  end

  it "responds to subscript and returns matching range" do
    assert_equal '1',      buffer[5]
    assert_equal 'line 2', buffer[7..12]
    assert_equal 'line 3', buffer[14..-2]
  end

  it "responds to each_line and yields each line" do
    buffer.each_line.with_index do |line, index|
      assert_equal buffer.lines[index], line.strip
    end
  end

  it "responds to from and returns text from matching line" do
    assert_equal "line 2\nline 3", buffer.from('2')
  end

  it "responds to lines_from and returns lines from matching line" do
    assert_equal ['line 2','line 3'], buffer.lines_from('2')
  end

  it "responds to match and returns MatchData object" do
    assert_instance_of MatchData, buffer.match(/2/)
    assert_equal nil, buffer.match(/4/)
  end

  it "responds to matches? and returns true or false" do
    assert_equal true, buffer.matches?(/2/)
    refute_equal true, buffer.matches?(/4/)
  end

  it "responds to contains? and returns true or false" do
    assert_equal true, buffer.contains?('2')
    refute_equal true, buffer.contains?('4')
  end

  it "responds to last_line_matches? and returns true or false" do
    assert_equal true, buffer.last_line_matches?(/3/)
    refute_equal true, buffer.last_line_matches?(/4/)
  end
end
