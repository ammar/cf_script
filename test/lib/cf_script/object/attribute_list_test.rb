require 'test_helper'

describe CfScript::AttributeList do
  subject {
    CfScript::AttributeList.new([
      CfScript::Attribute.new('one', 'UNO'),
      CfScript::Attribute.new('two', 'DUE'),
    ])
  }

  it "defines << method that adds attributes to the list" do
    subject << CfScript::Attribute.new('six', 'SEI')

    assert_equal 3, subject.length
  end

  it "raises an exception when duplicate attributes are added" do
    e = assert_raises(RuntimeError) {
      subject << CfScript::Attribute.new('one', 'DUPLICATE')
    }

    assert_equal "Duplicate attribute 'one'", e.message
  end

  it "delegates [] method to the underlying Hash" do
    assert_equal 'UNO', subject['one'].value
  end

  it "defines a names method that returns an Array of attribute names" do
    assert_equal ['one', 'two'], subject.names
  end

  it "defines a values method that returns an Array of attribute values" do
    assert_equal ['UNO', 'DUE'], subject.values
  end

  it "defines a to_h method that returns a Hash representation of the attributes" do
    expected = { 'one' => 'UNO', 'two' => 'DUE' }

    assert_equal expected, subject.to_h
  end
end
