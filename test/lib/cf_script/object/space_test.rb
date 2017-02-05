require 'test_helper'

describe CfScript::Space do
  subject { CfScript::Space }

  it "initializes all attributes to sensible defaults" do
    space = subject.new('outer-space')

    assert_equal 'outer-space', space.name

    assert_nil space.org

    assert_equal [], space.apps
    assert_equal [], space.domains
    assert_equal [], space.services
    assert_equal [], space.security_groups
  end

  it "sets all given attributes" do
    space = subject.new('space', 'ORG', [:app], [:domain], [:service], [:security])

    assert_equal 'space', space.name

    assert_equal 'ORG', space.org

    assert_equal [:app], space.apps
    assert_equal [:domain], space.domains
    assert_equal [:service], space.services
    assert_equal [:security], space.security_groups
  end
end
