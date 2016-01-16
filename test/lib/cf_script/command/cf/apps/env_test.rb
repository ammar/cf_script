require 'test_helper'

describe 'EnvCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::EnvCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :env,
    fails_with: {}
  }

  it "returns a Hash" do
    expected = {
      'SERVER_HOSTNAME' => 'host.example.com',
      'SERVER_HOSTPORT' => '1234',
      'SERVER_USERNAME' => 'name',
      'SERVER_PASSWORD' => 'word',
    }

    fake_cf do
      envs = command.run(:worker)

      assert_instance_of Hash, envs

      assert_equal expected.length, envs.length

      expected.each do |name, value|
        assert_equal expected[name], envs[name]
      end
    end
  end

  it "yields a Hash when a block is given" do
    fake_cf do
      called = false

      command.run(:worker) do |envs|
        assert_instance_of Hash, envs
        assert_equal 4, envs.length

        called = true
      end

      assert called, "Expected block to have been called"
    end
  end

  it "returns an empty Hash when no env variables are found" do
    fake_cf env: :empty_vars do
      assert_equal({}, command.run(:worker))
    end
  end
end
