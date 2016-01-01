require 'test_helper'

describe CfScript::Scope::App do
  include MockExecution

  let(:target) { CfScript::Target.new('API', 'ORG', 'staging') }

  subject { fake_cf { CfScript::Scope::App.new(:api, target) } }

  it "subclasses Scope::Base" do
    assert_kind_of CfScript::Scope::Base, subject
  end

  it "sets current_target" do
    assert subject.current_target, "Expected current_target to be set"
  end

  it "calls cf_self (which sets app_info) when initialized by name" do
    assert subject.app_info, "Expected app_info not to be nil"
    assert_instance_of CfScript::AppInfo, subject.app_info
  end

  it "calls cf_self (which completes the app_info) when initialized by AppInfo" do
    app = nil

    fake_cf do
      app_info = CfScript::AppInfo.new(:api, {})
      app = CfScript::Scope::App.new(app_info, target)
    end

    assert_equal 'stopped', subject.app_info.requested_state
    assert_equal '0/1', subject.app_info.instances
    assert_equal [], subject.app_info.urls
  end

  it "raises if initialized with anything other than a name or AppInfo" do
    assert_raises(RuntimeError) {
      fake_cf do
        app = CfScript::Scope::App.new([], target)
      end
    }
  end

  it "responds to current_space and returns it" do
    assert_equal 'staging', subject.current_space
  end

  it "reponds to name_tag and returns space:name" do
    assert_equal 'staging:api', subject.name_tag
  end

  it "reponds to tag_color and returns state" do
    subject.app_info.stub :state, 'started' do
      assert_equal :active, subject.tag_color
    end

    subject.app_info.stub :state, 'stopped' do
      assert_equal :inactive, subject.tag_color
    end
  end

  it "delegates to app_info for all data attributes" do
    assert_respond_to subject, :requested_state
    assert_respond_to subject, :instances
    assert_respond_to subject, :urls
    assert_respond_to subject, :usage
    assert_respond_to subject, :last_uploaded
    assert_respond_to subject, :stack
    assert_respond_to subject, :buildpack
    assert_respond_to subject, :memory
    assert_respond_to subject, :disk
    assert_respond_to subject, :state
    assert_respond_to subject, :started?
    assert_respond_to subject, :hot?
    assert_respond_to subject, :stopped?
    assert_respond_to subject, :cold?
  end

  it "includes the App::State module" do
    assert_respond_to subject, :start
    assert_respond_to subject, :stop
    assert_respond_to subject, :push
  end

  it "includes the App::Env module" do
    assert_respond_to subject, :env
    assert_respond_to subject, :set_env
    assert_respond_to subject, :unset_env
  end

  it "includes the App::Routes module" do
    assert_respond_to subject, :has_route?
    assert_respond_to subject, :map_route
    assert_respond_to subject, :unmap_route
  end

  it "includes the App::Utils module" do
    assert_respond_to subject, :dump
    assert_respond_to subject, :show
  end
end
