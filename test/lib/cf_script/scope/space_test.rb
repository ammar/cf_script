require 'test_helper'

describe CfScript::Scope::Space do
  include MockExecution

  it "behaves like a subclass of Scope::Target" do
    space = nil

    fake_cf target: :staging do
      space = CfScript::Scope::Space.new
    end

    assert_kind_of CfScript::Scope::Target, space

    assert_equal 'staging', space.current_space
  end

  it "calls target when initialized with a space name" do
    space = nil

    fake_cf target: :staging do
      space = CfScript::Scope::Space.new(:production)
    end

    assert_equal 'production', space.current_space
  end
end
