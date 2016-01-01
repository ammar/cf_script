require 'test_helper'

describe 'SetEnvCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::SetEnvCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :set_env,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do |o, e|
      result = command.run(:worker, 'NAME', 'VALUE')

      assert_equal true, result
    end
  end

  it "returns false if the output was empty" do
    fake_cf set_env: :empty do
      result = command.run(:app, 'NAME', 'VALUE')

      assert_equal false, result
    end
  end

  it "prints an error on failure" do
    fake_cf set_env: :not_found do |stdout, stderr|
      result = command.run(:api, 'API_PASSWORD', 'password')

      assert_equal false, result
      assert_match /\{set_env\} FAILED/, stderr.lines.first
    end
  end
end
