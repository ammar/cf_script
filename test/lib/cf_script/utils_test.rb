require 'test_helper'

describe CfScript::Utils do
  subject { CfScript::Utils }

  it "defines a symbolize method that symbolizes a string" do
    assert_equal :foo_bar, subject.symbolize('foo bar')
    assert_equal :foo_bar, subject.symbolize('foo-bar')
    assert_equal :foo_bar, subject.symbolize('foo.bar')
  end

  it "defines a symbolize_keys method that symbolizes the keys of a Hash" do
    input  = { 'foo-bar' => 'baz' }
    output = subject.symbolize_keys(input)

    expected = { foo_bar: 'baz' }

    assert_equal expected, output
  end
end
