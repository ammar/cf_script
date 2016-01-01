require 'test_helper'

describe 'UnsetEnvCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::UnsetEnvCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :unset_env,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do |o, e|
      result = command.run(:worker, 'NAME')

      assert_equal true, result
    end
  end

  it "returns false if the output was empty" do
    fake_cf unset_env: :empty do
      result = command.run(:app, 'NAME')

      assert_equal false, result
    end
  end

  it "prints an error on failure" do
    fake_cf unset_env: :not_found do |stdout, stderr|
      result = command.run(:bogus, 'VAR_NAME')

      assert_equal false, result
      assert_match /\{unset_env\} FAILED/, stderr.lines.first
    end
  end
end
