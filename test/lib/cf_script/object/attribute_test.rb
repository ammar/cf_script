require 'test_helper'

describe CfScript::Attribute do
  subject { CfScript::Attribute }

  it "preserves the name and value as given" do
    { :foo  => :bar,
      'foo' => 'bar'
    }.each do |name, value|
      var = subject.new(name, value)

      assert_equal name, var.name
      assert_equal value, var.value
    end
  end

  it "defines to_a methods that splits the value on commas + zero or more space" do
    var = subject.new('list', 'a, b,  c,d')

    assert_equal ['a', 'b', 'c', 'd'], var.to_a
  end

  it "defines a to_s that returns a formatted string representation" do
    var = subject.new(:foo, :bar)

    assert_equal "foo: bar", var.to_s
    assert_equal "foo: bar", var.inspect
  end
end
