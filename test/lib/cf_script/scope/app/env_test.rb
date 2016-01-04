require 'test_helper'

describe CfScript::Scope::App::Env do
  include MockExecution

  let(:target) { CfScript::Target.new('API', 'ORG', 'staging') }

  def create_app(name)
    app = nil
    fake_cf { app = CfScript::Scope::App.new(:api, target) }
    app
  end

  it "defines an env method that calls Command.env with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :env, command
      assert_equal [:api], args

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.env
    end
  end

  it "defines a set_env method that calls Command.set_env with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :set_env, command
      assert_equal [:api, 'name', 'value'], args

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.set_env('name', 'value')
    end
  end

  it "defines an unset_env method that calls Command.unset_env with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :unset_env, command
      assert_equal [:api, 'name'], args

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.unset_env('name')
    end
  end
end
