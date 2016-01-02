require 'test_helper'

describe 'StopCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::StopCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :stop,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:worker)
    end
  end

  it "prints an error on failure" do
    fake_cf stop: :not_found do |stdout, stderr|
      command.run(:bogus)

      assert_match /\{stop\} failed to stop/, stderr.lines.first
    end
  end

  it "returns false when the app is not found" do
    fake_cf stop: :not_found do |stdout, stderr|
      assert_equal false, command.run(:bogus)

      assert_match /\{stop\} failed to stop/, stderr.lines.first
    end
  end
end
