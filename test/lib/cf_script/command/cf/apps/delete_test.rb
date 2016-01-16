require 'test_helper'

describe 'DeleteCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::DeleteCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :delete,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:name)
    end
  end

  it "prints an error on failure" do
    fake_cf delete: :not_exist do |stdout, stderr|
      command.run(:name)

      assert_match /\{delete\} failed to delete app/, stderr.lines.first
    end
  end

  it "skips flags when false" do
    assert_command_args command,
      [:worker],
      [:worker, { flags: [] }]
  end

  it "adds flag for force when true" do
    assert_command_args command,
      [:worker, true],
      [:worker, { flags: [:f] }]
  end

  it "adds flag for delete routes when true" do
    assert_command_args command,
      [:worker, false, true],
      [:worker, { flags: [:r] }]
  end

  it "adds flags for force and delete routes when true" do
    assert_command_args command,
      [:worker, true, true],
      [:worker, { flags: [:f, :r] }]
  end
end
