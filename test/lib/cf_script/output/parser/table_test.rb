require 'test_helper'

describe CfScript::Output::Parser::Table do
  attr_accessor :parser

  attr_accessor :text_buffer

  class TableParserTest
    include CfScript::Utils
    include CfScript::Output::Parser::Attributes
    include CfScript::Output::Parser::Table
  end

  def setup
    @parser = TableParserTest.new

    @text_buffer = "Something\n\n" +
      "         value   another value     final value \n"+
      "one      123     A bit long        Last one\n" +
      "two      234     Short             \n" +
      "tre      345     Third             End\n" +
      "\n"
  end

  describe "parse_columns" do
    it "returns an Array with the column names" do
      cols = parser.parse_columns(text_buffer.lines[2])

      assert_instance_of Array, cols
      assert_equal 4, cols.length
    end

    it "strips white space before/after column names" do
      cols = parser.parse_columns(text_buffer.lines[2])

      assert_equal [
        '',
        'value',
        'another value',
        'final value'
      ], cols
    end
  end

  describe "parse_row" do
    it "returns an AttributeList object" do
      cols = parser.parse_columns(text_buffer.lines[2])
      row  = parser.parse_row(text_buffer.lines[3], cols)

      assert_instance_of CfScript::AttributeList, row
    end

    it "symbolizes attribute names" do
      cols = parser.parse_columns(text_buffer.lines[2])
      row  = parser.parse_row(text_buffer.lines[3], cols)

      assert_equal [
        :index, :value, :another_value, :final_value
      ], row.names
    end

    it "strips whitespace surrounding values" do
      cols = parser.parse_columns(text_buffer.lines[2])
      row  = parser.parse_row(text_buffer.lines[4], cols)

      assert_equal [
        "two", "234", "Short", ""
      ], row.values
    end
  end

  describe "parse_rows" do
    it "returns an Array of AttributeList objects" do
      rows = parser.parse_rows(text_buffer.lines)

      assert_instance_of Array, rows
      rows.each do |row|
        assert_instance_of CfScript::AttributeList, row
      end
    end

    it "returns an empty Array if no table is found" do
      rows = parser.parse_rows([''])

      assert_instance_of Array, rows
      assert_equal [], rows
    end
  end

  describe "parse_table" do
    it "returns an Array of AttributeList objects" do
      rows = parser.parse_table(text_buffer, [
        '', 'value', 'another value', 'final value'
      ])

      assert_instance_of Array, rows
      rows.each do |row|
        assert_instance_of CfScript::AttributeList, row
      end
    end

    it "returns nil of nothing matched" do
      rows = parser.parse_table(text_buffer, ['foo'])

      assert_equal nil, rows
    end
  end
end
