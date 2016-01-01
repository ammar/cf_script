require 'test_helper'

describe 'LogoutCommand' do
  include MockExecution

  let(:command) { CfScript::Command::General::LogoutCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :general,
    has_name:  :logout,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run
    end
  end

  describe "with a block" do
    it "yields true" do
      fake_cf do
        called = false

        command.run do |logged_out|
          assert_equal true, logged_out
          called = true
        end

        assert called, "Expected block to have been called"
      end
    end
  end
end
