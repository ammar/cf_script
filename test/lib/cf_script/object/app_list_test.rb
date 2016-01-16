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
      CfScript::AppInfo.new('org-api', api_attrs),
    ])
  end

  it "initializes list to an empty Array" do
    app_list = CfScript::AppList.new

    assert_equal 0, app_list.length
  end

  it "defines a names method that returns an array of names" do
    assert_instance_of Array, list.names
    assert_equal ['one-worker', 'two-engine', 'org-api'], list.names
  end

  describe '==' do
    it "returns true when the lists contain the same names" do
      other = CfScript::AppList.new([
        CfScript::AppInfo.new('one-worker', {}),
        CfScript::AppInfo.new('two-engine', {}),
        CfScript::AppInfo.new('org-api',    {}),
      ])

      assert_equal true, other == list
    end

    it "returns false when the lists have different names" do
      other = CfScript::AppList.new([
        CfScript::AppInfo.new('one-engine', {}),
        CfScript::AppInfo.new('two-worker', {}),
        CfScript::AppInfo.new('org-api',    {}),
      ])

      assert_equal false, other == list
    end
  end

  describe 'each_name' do
    it "yields the app name in the list" do
      names = []

      list.each_name do |name|
        names << name
      end

      assert_equal names, list.names
    end
  end

  describe 'each' do
    it "yields each AppInfo instance in the list" do
      infos = []

      list.each do |info|
        infos << info
      end

      infos.each_with_index do |info, index|
        assert_equal info, list[index]
      end
    end
  end

  it "selects by suffix" do
    list.select!(ending_with: 'worker')

    assert_equal 1, list.length
    assert_equal 'one-worker', list.first.name
  end

  it "selects by matching" do
    list.select!(matching: 'api')

    assert_equal 1, list.length
    assert_equal 'org-api', list.first.name
  end

  it "selects by prefix" do
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
