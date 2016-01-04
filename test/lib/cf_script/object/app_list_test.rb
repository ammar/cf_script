require 'test_helper'

describe CfScript::AppList do
  include ObjectHelpers

  attr_accessor :list

  def setup
    one_attrs = build_attribute_list(
      requested_state: 'started',
      urls:            'example.com',
    )

    two_attrs = build_attribute_list(
      requested_state: 'stopped',
      urls:            'example.com',
    )

    api_attrs = build_attribute_list(
      requested_state: 'started',
      urls:            'example.com',
    )

    @list = CfScript::AppList.new([
      CfScript::AppInfo.new('one-worker', one_attrs),
      CfScript::AppInfo.new('two-engine', two_attrs),
      CfScript::AppInfo.new('org-api-blue', api_attrs),
    ])
  end

  it "initializes list to an empty Array" do
    app_list = CfScript::AppList.new

    assert_equal 0, app_list.length
  end

  it "selects by prefix" do
    list.select!(ending_with: 'worker')

    assert_equal 1, list.length
    assert_equal 'one-worker', list.first.name
  end

  it "selects by contains" do
    list.select!(contains: 'api')

    assert_equal 1, list.length
    assert_equal 'org-api-blue', list.first.name
  end

  it "selects by suffix" do
    list.select!(starting_with: 'two')

    assert_equal 1, list.length
    assert_equal 'two-engine', list.first.name
  end

  it "selects by state" do
    list.select!(state: 'stopped')

    assert_equal 1, list.length
    assert_equal 'two-engine', list.first.name
  end
end
