require 'test_helper'

describe CfScript::InstanceStatus do
  include ObjectHelpers

  attr_accessor :instance_status

  def setup
    @instance_status = build_instance_status
  end

  it "initializes all attributes to sensible defaults" do
    status = CfScript::InstanceStatus.new

    assert_equal nil, status.index
    assert_equal nil, status.state
    assert_equal nil, status.since
    assert_equal nil, status.cpu
    assert_equal nil, status.memory
    assert_equal nil, status.disk
    assert_equal nil, status.details
  end

  it "initializes given attributes" do
    assert_equal '0', @instance_status.index
    assert_equal '1', @instance_status.state
    assert_equal '2', @instance_status.since
    assert_equal '3', @instance_status.cpu
    assert_equal '4', @instance_status.memory
    assert_equal '5', @instance_status.disk
    assert_equal '6', @instance_status.details
  end

  it "shows requested attributes" do
    assert_equal 'since: 2, memory: 4', @instance_status.show(:since, :memory)
  end
end
