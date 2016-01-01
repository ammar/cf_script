require 'test_helper'

describe CfScript::Output::Parser::Attributes do
  attr_accessor :parser

  attr_accessor :text_buffer
  attr_accessor :line_buffer
  attr_accessor :line_regexp

  class AttributesParserTest
    include CfScript::Utils
    include CfScript::Output::Parser::Attributes
    include CfScript::Output::Parser::Section
  end

  def setup
    @parser = AttributesParserTest.new

    @text_buffer = "" +
      "one: first  \n" +
      "  two: second \n" +
      "tre  : last\n"

    @line_buffer = "one: first , two: second, tre: last   "
    @line_regexp = /one: (?<one>[^,]+), two: (?<two>[^,]+), tre: (?<tre>.+)/
  end

  describe "parse_attribute" do
    it "returns an Attribute object" do
      attr = parser.parse_attribute(text_buffer.lines[0])

      assert_instance_of CfScript::Attribute, attr
      assert_equal 'one', attr.name
      assert_equal 'first', attr.value
    end

    it "symbolizes attribute names when specified" do
      attr = parser.parse_attribute(text_buffer.lines[0], true)

      assert_equal :one, attr.name
    end

    it "strips preceeding/following whitespace" do
      tests = [
        ['one', 'first'],
        ['two', 'second'],
        ['tre', 'last'],
      ]

      tests.each_with_index do |pair, index|
        attr = parser.parse_attribute(text_buffer.lines[index])

        assert_equal pair.first, attr.name
        assert_equal pair.last,  attr.value
      end
    end
  end

  describe "parse_attribute_list" do
    it "returns an AttributeList object" do
      list = parser.parse_attribute_list(text_buffer)

      assert_instance_of CfScript::AttributeList, list
      assert_equal 3, list.length
    end

    it "symbolizes attribute names when specified" do
      list = parser.parse_attribute_list(text_buffer, true)

      assert_equal [:one, :two, :tre], list.names
    end
  end

  describe "parse_line_attributes" do
    it "returns an AttributeList object" do
      list  = parser.parse_line_attributes(line_buffer, line_regexp)

      assert_instance_of CfScript::AttributeList, list
      assert_equal 3, list.length
    end

    it "symbolizes attribute names" do
      list = parser.parse_line_attributes(line_buffer, line_regexp)

      assert_equal [:one, :two, :tre], list.names
    end

    it "strips preceeding/following whitespace" do
      tests = [
        [:one, 'first'],
        [:two, 'second'],
        [:tre, 'last'],
      ]

      list = parser.parse_line_attributes(line_buffer, line_regexp)
      tests.each_with_index do |pair, index|
        assert_equal pair.first, list[list.names[index]].name
        assert_equal pair.last,  list[list.names[index]].value
      end
    end
  end
end
