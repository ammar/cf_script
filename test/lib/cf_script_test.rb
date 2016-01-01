require 'test_helper'

describe CfScript do
  include MockExecution

  it "defines a config method that returns the Config object" do
    assert CfScript.respond_to? :config

    config = CfScript.config

    assert_instance_of CfScript::Config, config
    assert_same CfScript.config, config
  end

  it "defines a configure method that yields the Config object" do
    assert CfScript.respond_to? :configure

    called = false

    CfScript.configure do |config|
      called = true

      assert_instance_of CfScript::Config, config
      assert_same CfScript.config, config
    end

    assert called, 'Expected configure to yield to the block'
  end

  it "defines stdout/stderr methods that return the configured IO objects" do
    assert CfScript.respond_to? :stdout
    assert_same CfScript.config.io.stdout, CfScript.stdout

    assert CfScript.respond_to? :stderr
    assert_same CfScript.config.io.stderr, CfScript.stderr
  end

  it "works when cf calls are nested" do
    space_sequence = []

    fake_cf do
      cf space: :development do
        space_sequence << current_space

        cf space: :staging do
          space_sequence << current_space

          cf space: :production do
            space_sequence << current_space
          end

          space_sequence << current_space
        end

        space_sequence << current_space
      end
    end

    assert_equal 'development', space_sequence[0]
    assert_equal 'staging',     space_sequence[1]
    assert_equal 'production',  space_sequence[2]
    assert_equal 'staging',     space_sequence[3]
    assert_equal 'development', space_sequence[4]
  end

  it "doesn't expose private methods" do
    refute CfScript.respond_to?(:stack_level)
    assert CfScript.singleton_class.private_method_defined?(:stack_level)

    refute CfScript.respond_to?(:print_error)
    assert CfScript.singleton_class.private_method_defined?(:print_error)
  end
end
