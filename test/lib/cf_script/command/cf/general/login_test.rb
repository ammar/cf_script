require 'test_helper'

describe 'LoginCommand' do
  include MockExecution

  let(:command) { CfScript::Command::General::LoginCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :general,
    has_name:  :login,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run('user', 'pass')
    end
  end

  it "include api, org, and space options" do
    options = {
      api:    'https://api.example.io',
      org:    'ACME',
      space:  'staging'
    }

    assert_command_args command,
      ['user', 'pass', options],
      [{
        u: 'user',
        p: 'pass',
        a: 'https://api.example.io',
        o: 'ACME',
        s: 'staging'
      }]
  end

  it "returns false when credentials get rejected" do
    fake_cf login: :rejected do
      assert_equal false, command.run('user', 'pass')
    end
  end

  it "prints an error when credentials get rejected" do
    fake_cf login: :rejected do |stdout, stderr|
      command.run('user', 'pass')

      assert_includes stdout.lines, "<running> cf login -u user -p [PASSWORD HIDDEN]\n"
      assert_includes stderr.lines, "{login} Credentials were rejected\n"
    end
  end

  describe "with a block" do
    it "yields true on success" do
      fake_cf do
        called = false

        command.run 'user', 'pass' do |logged_in|
          assert_equal true, logged_in
          called = true
        end

        assert called, "Expected block to have been called"
      end
    end

    it "does not yield on failure" do
      fake_cf login: :fail do
        called = false

        command.run 'user', 'pass' do |logged_in|
          called = true
        end

        refute called, "Expected block to not have been called"
      end
    end
  end
end
