require 'test_helper'

describe CfScript::Command::Base do
  class TestCommand < CfScript::Command::Base
    def initialize
      super(:test, :dummy)
    end
  end

  it "defines a line method that returns a Command::Line object" do
    line = TestCommand.instance.line({}, 'cf', [])

    assert_instance_of CfScript::Command::Line, line
  end

  it "raises an exception if run is called" do
    assert_raises(RuntimeError) {
      TestCommand.instance.run
    }
  end
end
