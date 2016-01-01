require 'test_helper'

describe CfScript::Output::Parser::Section do
  attr_accessor :parser

  attr_accessor :text_buffer

  class SectionParserTest
    include CfScript::Utils
    include CfScript::Output::Parser::Attributes
    include CfScript::Output::Parser::Section
  end

  def setup
    @parser = SectionParserTest.new

    @text_buffer = "\n" +
      "Something else going on here\n" +
      "Section Title:\n" +
      " one: 1\n" +
      " two: 2\n" +
      " tre: 3\n" +
      "\nSomething else"
  end

  describe "extract_section" do
    it "returns extracted text" do
      section = parser.extract_section(text_buffer, 'Section Title')

      assert_equal " one: 1\n two: 2\n tre: 3", section
    end
  end

  describe "parse_section_attributes" do
    it "calls parse_attribute_list" do
      parser.stub :parse_attribute_list, 'called' do
        assert_equal 'called', parser.parse_section_attributes(text_buffer, 'Section Title')
      end
    end

    it "returns an AttributeList object" do
      list = parser.parse_section_attributes(text_buffer, 'Section Title')

      assert_instance_of CfScript::AttributeList, list
      assert_equal 3, list.length
    end

    it "doesn't symbolize attribute names" do
      list = parser.parse_section_attributes(text_buffer, 'Section Title')

      assert_equal ['one', 'two', 'tre'], list.names
    end

    it "returns nil if the section title is not found" do
      list = parser.parse_section_attributes(text_buffer, 'NOPE')

      assert_equal nil, list
    end
  end
end
