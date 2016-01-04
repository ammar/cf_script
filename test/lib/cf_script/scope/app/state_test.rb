require 'test_helper'

describe CfScript::Scope::App::State do
  include MockExecution

  let(:target) { CfScript::Target.new('API', 'ORG', 'staging') }

  def create_app(name)
    app = nil
    fake_cf { app = CfScript::Scope::App.new(:api, target) }
    app
  end

  it "defines a start method that calls Command.start with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :start, command
      assert_equal [:api], args

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.start
    end
  end

  it "defines a stop method that calls Command.stop with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :stop,  command
      assert_equal [:api], args

      return :called
    end

    app.stub :cf_self, true do
      CfScript::Command.stub :run, arg_catcher do
        assert_equal :called, app.stop
      end
    end
  end

  it "defines a restart method that calls Command.restart with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :restart,  command
      assert_equal [:api], args

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.restart
    end
  end

  it "defines a push method that calls Command.push with the app name and options" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :push,  command
      assert_equal :api, args.first
      assert_equal({ memory: '128MB' }, args.last)

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.push({ memory: '128MB' })
    end
  end

  it "defines a restage method that calls Command.restage with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :restage,  command
      assert_equal [:api], args

      return :called
    end

    CfScript::Command.stub :run, arg_catcher do
      assert_equal :called, app.restage
    end
  end
end
