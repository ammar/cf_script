require 'test_helper'

describe CfScript::AppInfo do
  include ObjectHelpers

  attr_reader   :urls
  attr_reader   :last_uploaded
  attr_reader   :buildpack

  attr_accessor :empty_attrs
  attr_accessor :apps_attrs
  attr_accessor :app_attrs
  attr_accessor :instance_attrs

  def setup
    @urls          = 'projects.example.com, projects.example.io'
    @last_uploaded = 'Fri Dec 25 00:00:00 UTC 2015'
    @buildpack     = 'https://github.com/cloudfoundry/binary-buildpack.git'

    @empty_attrs = CfScript::AttributeList.new

    @apps_attrs = build_attribute_list(
      requested_state:  'started',
      instances:        '1/2',
      memory:           '1G',
      disk:             '2G',
      urls:             @urls,
    )

    @app_attrs = build_attribute_list(
      requested_state:  'started',
      instances:        '1/2',
      usage:            '1G x 1 instances',
      urls:             @urls,
      last_uploaded:    @last_uploaded,
      stack:            'cflinuxfs2',
      buildpack:        @buildpack,
    )
  end

  it "initializes missing attributes to sensible defaults" do
    info = CfScript::AppInfo.new('name', empty_attrs)

    assert_equal 'name',  info.name
    assert_nil            info.requested_state
    assert_nil            info.instances
    assert_equal [],      info.urls
    assert_nil            info.usage
    assert_nil            info.last_uploaded
    assert_nil            info.stack
    assert_nil            info.buildpack
    assert_nil            info.memory
    assert_nil            info.disk
  end

  it "sets apps command attributes when given" do
    info = CfScript::AppInfo.new('projects', apps_attrs)

    assert_equal 'projects',              info.name
    assert_equal 'started',               info.requested_state
    assert_equal '1/2',                   info.instances
    assert_equal 2,                       info.urls.length
    assert_equal 'projects.example.com',  info.urls.first
    assert_equal 'projects.example.io',   info.urls.last
    assert_nil                            info.usage
    assert_nil                            info.last_uploaded
    assert_nil                            info.stack
    assert_nil                            info.buildpack
    assert_equal '1G',                    info.memory
    assert_equal '2G',                    info.disk
  end

  it "sets app command attributes when given" do
    info = CfScript::AppInfo.new('projects', app_attrs)

    assert_equal 'projects',              info.name
    assert_equal 'started',               info.requested_state
    assert_equal '1/2',                   info.instances
    assert_equal 2,                       info.urls.length
    assert_equal 'projects.example.com',  info.urls.first
    assert_equal 'projects.example.io',   info.urls.last
    assert_equal '1G x 1 instances',      info.usage
    assert_equal last_uploaded,           info.last_uploaded
    assert_equal 'cflinuxfs2',            info.stack
    assert_equal buildpack,               info.buildpack
    assert_equal '1G',                    info.memory # Extracted from usage
    assert_nil                            info.disk
  end

  it "defines state method that return value of requested_state" do
    info = CfScript::AppInfo.new('projects', app_attrs)

    assert_respond_to info, :state
    assert_equal 'started', info.state
  end

  it "defines started? and stopped? methods and hot?, cold? aliases" do
    info = CfScript::AppInfo.new('projects', app_attrs)

    assert_respond_to info, :started?
    assert_respond_to info, :hot?

    assert_respond_to info, :stopped?
    assert_respond_to info, :cold?

    assert_equal true, info.started?
    assert_equal true, info.hot?

    refute_equal true, info.stopped?
    refute_equal true, info.cold?
  end

  it "defines set_intance_status method that takes attribute lists and builds InstanceStatus objects" do
    info = CfScript::AppInfo.new('projects', app_attrs)

    info.set_instance_status [
      build_instance_status_attrs(index: '0'),
      build_instance_status_attrs(index: '1'),
      build_instance_status_attrs(index: '2'),
    ]

    assert_equal 3,   info.instance_status.length
    assert_equal '0', info.instance_status[0].index
    assert_equal '1', info.instance_status[1].index
    assert_equal '2', info.instance_status[2].index
  end
end
