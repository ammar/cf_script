require 'test_helper'

describe CfScript::Output do
  include MockExecution

  attr_accessor :output

  def setup
    @output = fake_output(
      "one: first\n" +
      "two: second, place: middle\n" +
      "third: last\n\n" +
      "col1    col2\n" +
      "val1    val2\n" +
      "val3    val4\n",

      "stderr",

      0
    )
  end

  it "responds to good? and returns true if exit status == 0" do
    assert output.respond_to?(:good?)
    assert output.good?
  end

  it "responds to good? and returns false if exit status != 0" do
    refute fake_output('', '', 1).good?
  end

  it "responds to out and returns a Buffer object" do
    assert_instance_of CfScript::Output::Buffer, output.out
  end

  it "responds to err and returns a Buffer object" do
    assert_instance_of CfScript::Output::Buffer, output.err
  end

  it "responds to last_line and returns last line of stdout" do
    assert_equal 'val3    val4', output.last_line
  end

  describe "attributes" do
    it "calls parse_attribute_list" do
      assert output.respond_to?(:attributes)

      output.stub :parse_attribute_list, 'called' do
        assert_equal 'called', output.attributes
      end
    end

    it "returns an AttributeList object" do
      assert_instance_of CfScript::AttributeList, output.attributes
      assert_equal 3, output.attributes.length
    end
  end

  describe "line_attributes" do
    it "calls parse_line_attributes" do
      assert output.respond_to?(:line_attributes)

      output.stub :parse_line_attributes, 'called' do
        assert_equal 'called', output.line_attributes(/a/)
      end
    end

    it "returns an AttributeList object" do
      regex = /two: (?<position>[^,]+), place: (?<index>.+)/
      attrs = output.line_attributes(regex)

      assert_instance_of CfScript::AttributeList, attrs
      assert_equal 2, attrs.length

      assert_equal 'second', attrs[:position].value
      assert_equal 'middle', attrs[:index].value
    end
  end

  describe "attributes_from" do
    it "calls from on out buffer" do
      expected = { from: 'called' }

      output.out.stub :from, 'from: called' do
        assert_equal expected, output.attributes_from('foo').to_h
      end
    end

    it "calls parse_attribute_list" do
      assert output.respond_to?(:attributes_from)

      output.stub :parse_attribute_list, 'called' do
        assert_equal 'called', output.attributes_from('two')
      end
    end

    it "returns an AttributeList object" do
      attrs = output.attributes_from('third')

      assert_instance_of CfScript::AttributeList, attrs
      assert_equal 1, attrs.length

      assert_equal 'last', attrs[:third].value
    end
  end

  describe "table" do
    it "calls parse_table" do
      assert output.respond_to?(:table)

      output.stub :parse_table, 'called' do
        assert_equal 'called', output.table([])
      end
    end

    it "returns an Array of AttributeList objects" do
      rows = output.table(['col1', 'col2'])

      assert_instance_of Array, rows
      assert_instance_of CfScript::AttributeList, rows.first
      assert_equal 2, rows.length
    end
  end

  describe "section_attributes" do
    it "calls parse_section_attributes" do
      assert output.respond_to?(:section_attributes)

      output.stub :parse_section_attributes, 'called' do
        assert_equal 'called', output.section_attributes('header')
      end
    end
  end
end
