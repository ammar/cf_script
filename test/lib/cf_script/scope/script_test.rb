require 'test_helper'

describe CfScript::Scope::Script do
  include MockExecution

  it "behaves like a subclass of Scope::Target" do
    script = nil

    fake_cf target: :production do
      script = CfScript::Scope::Script.new
    end

    assert_kind_of CfScript::Scope::Target, script
    assert_equal 'production', script.current_space
  end

  it "responds to run and calls exec_in with self and the block" do
    script = nil

    fake_cf target: :staging do
      script = CfScript::Scope::Script.new
    end

    assert script.respond_to?(:run), "Expected Scope::Script to respond to run"

    arg_catcher = lambda do |scope, args, &block|
      assert_same script, scope
      return :called
    end

    script.stub :exec_in, arg_catcher do
      assert_equal :called, script.run { nil }
    end
  end

  it "calls the api command when the api option is given without login options" do
    script = nil

    fake_cf do
      script = CfScript::Scope::Script.new({ api: :ipa })

      arg_catcher = lambda do |command, args, &block|
        assert_equal :api, command
        assert_equal :ipa, args
      end

      CfScript::Command.stub :run, arg_catcher do
        script.apply_options()
      end
    end
  end

  it "calls the login command when the user/pass options are given" do
    script  = nil
    options = { api: :skip, username: :name, password: :word, space: :skip }

    fake_cf do
      script = CfScript::Scope::Script.new(options)

      arg_catcher = lambda do |command, *args, &block|
        assert_equal :login,  command
        assert_equal :name,   args[0]
        assert_equal :word,   args[1]
        assert_equal options, args[2]
      end

      CfScript::Command.stub :run, arg_catcher do
        script.apply_options()
      end
    end
  end

  it "calls the target command when the space option is given without login options" do
    script = nil

    fake_cf do
      script = CfScript::Scope::Script.new({ space: :staging })

      arg_catcher = lambda do |command, args, &block|
        assert_equal :target,  command
        assert_equal :staging, args
      end

      CfScript::Command.stub :run, arg_catcher do
        script.apply_options()
      end
    end
  end
end
