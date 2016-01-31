require 'test_helper'

describe CfScript::Command::Registry do
  subject { CfScript::Command::Registry.new }

  class DummyCommand < CfScript::Command::Base
    def initialize
      super(:test, :dummy)
    end
  end

  it "starts with zero commands" do
    assert_equal({}, subject.commands)
  end

  describe "known?" do
    it "returns false when given command is not registered" do
      assert_equal false, subject.known?(:dummy)
    end

    it "returns true when given command is registered" do
      subject.add! DummyCommand

      assert_equal true, subject.known?(:dummy)
    end
  end

  describe "check!" do
    it "raises an exception for unknown commands" do
      assert_raises(CfScript::Command::Registry::UnimplementedCommand) {
        subject.check! :dummy
      }
    end
  end

  describe "add!" do
    it "adds commands" do
      assert_equal false, subject.known?(:dummy)

      subject.add! DummyCommand

      assert_equal true, subject.known?(:dummy)
    end

    it "raises an exception for duplicate commands" do
      subject.add! DummyCommand

      assert_raises(CfScript::Command::Registry::DuplicateCommand) {
        subject.add! DummyCommand
      }
    end
  end
end
