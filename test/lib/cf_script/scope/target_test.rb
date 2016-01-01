require 'test_helper'

describe CfScript::Scope::Target do
  include MockExecution

  subject {
    target = nil

    fake_cf target: :staging do
      target = CfScript::Scope::Target.new
    end

    target
  }

  it "sets initial_target and current_target on initialize" do
    initial_target = subject.instance_variable_get('@initial_target')
    current_target = subject.instance_variable_get('@current_target')

    assert initial_target
    assert current_target

    assert_instance_of CfScript::Target, initial_target
    assert_instance_of CfScript::Target, current_target

    assert_equal 'staging', initial_target.space
    assert_equal 'ACME',    initial_target.org

    assert_equal 'staging', current_target.space
    assert_equal 'ACME',    current_target.org
  end

  it "updates current_target when target is called" do
    fake_cf target: :production do
      assert_equal 'staging', subject.current_space
      assert_equal 'ACME',    subject.current_org

      subject.target(:production)
      assert_equal 'production', subject.current_space
      assert_equal 'ACME',       subject.current_org
    end
  end

  it "resets target to initial_target if the space has changed" do
    fake_cf target: :production do
      subject.target(:production)
      assert_equal 'production', subject.current_space
      assert_equal 'ACME',       subject.current_org

      subject.finalize
      assert_equal 'staging', subject.current_space
      assert_equal 'ACME',    subject.current_org
    end
  end

  it "resets target to initial_target if the org has changed" do
    fake_cf do
      subject.target(:staging_org)
      assert_equal 'staging', subject.current_space
      assert_equal 'ORG',     subject.current_org

      subject.finalize
      assert_equal 'staging', subject.current_space
      assert_equal 'ACME',    subject.current_org
    end
  end

  it "responds to target without args and calls Command.run" do
    assert subject.respond_to?(:target)

    CfScript::Command.stub :run, :called do
      assert_equal :called, subject.target
    end
  end

  it "responds to target with a space name and calls Command.run if not == current" do
    assert subject.respond_to?(:target)

    assert_equal 'staging', subject.current_space

    CfScript::Command.stub :run, :called do
      assert_equal :called, subject.target(:production)
    end
  end

  it "returns current target if it's the same as the requested target" do
    current_target = subject.instance_variable_get('@current_target')

    CfScript::Command.stub :run, :called do
      assert_same current_target, subject.target(:staging)
    end
  end

  it "responds to space and calls Command.run" do
    assert subject.respond_to?(:space)

    CfScript::Command.stub :run, :called do
      assert_equal :called, subject.space(:foo)
    end
  end

  it "responds to space with a block and calls exec_in with a Space scope" do
    assert subject.respond_to?(:space)

    arg_catcher = lambda do |scope, args, &block|
      assert_instance_of CfScript::Scope::Space, scope
    end

    fake_cf do
      subject.stub :exec_in, arg_catcher do
        assert subject.space(:staging) { nil }
      end
    end
  end

  it "responds to app and calls Command.run" do
    assert subject.respond_to?(:app)

    CfScript::Command.stub :run, :called do
      assert_equal :called, subject.app(:foo)
    end
  end

  it "responds to app with a block and calls exec_in with an App scope" do
    assert subject.respond_to?(:app)

    arg_catcher = lambda do |scope, args, &block|
      assert_instance_of CfScript::Scope::App, scope
    end

    fake_cf do
      subject.stub :exec_in, arg_catcher do
        assert subject.app(:worker) { nil }
      end
    end
  end

  it "responds to apps and calls Command.run" do
    assert subject.respond_to?(:apps)

    CfScript::Command.stub :run, :called do
      assert_equal :called, subject.apps
    end
  end

  it "calls apps.select! when options is not empty" do
    assert subject.respond_to?(:apps)

    apps = MiniTest::Mock.new
    apps.expect(:select!, apps, [{ ending_with: :foo }])

    CfScript::Command.stub :run, apps do
      subject.apps(ending_with: :foo)
    end

    apps.verify
  end
end
