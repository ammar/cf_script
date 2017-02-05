require 'test_helper'

describe 'RestartAppInstanceCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::RestartAppInstanceCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :restart_app_instance,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:worker, 0)
    end
  end

  it "prints an error on failure" do
    fake_cf restart_app_instance: :not_found do |stdout, stderr|
      command.run(:bogus, 0)

      assert_match(
        /\{restart_app_instance\} failed to restart app instance 0/,
        stderr.lines.first
      )
    end
  end

  it "returns false when the app is not found" do
    fake_cf restart_app_instance: :not_found do |stdout, stderr|
      assert_equal false, command.run(:bogus, 0)

      assert_match(
        /\{restart_app_instance\} failed to restart app instance 0/,
        stderr.lines.first
      )
    end
  end
end
