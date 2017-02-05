require 'test_helper'

describe 'RenameCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::RenameCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :rename,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:old, :new)
    end
  end

  it "prints an error on failure" do
    fake_cf rename: :not_found do |stdout, stderr|
      command.run(:old, :new)

      assert_match(/\{rename\} failed to rename/, stderr.lines.first)
    end
  end

  it "returns false when the app is not found" do
    fake_cf rename: :not_found do |stdout, stderr|
      assert_equal false, command.run(:old, :new)

      assert_match(/\{rename\} failed to rename/, stderr.lines.first)
    end
  end
end
