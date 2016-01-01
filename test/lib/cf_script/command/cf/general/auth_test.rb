require 'test_helper'

describe 'AuthCommand' do
  include MockExecution

  let(:command) { CfScript::Command::General::AuthCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :general,
    has_name:  :auth,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run('user', 'pass')
    end
  end

  it "returns false when credentials get rejected" do
    fake_cf auth: :rejected do
      assert_equal false, command.run('user', 'pass')
    end
  end

  it "returns false if the output is empty" do
    fake_cf auth: :empty do
      result = command.run('name', 'word')

      assert_equal false, result
    end
  end

  it "hides the password in trace messages" do
    fake_cf do |stdout, stderr|
      command.run('user', 'pass')

      assert_includes stdout, "<running> cf auth user [PASSWORD HIDDEN]\n"
    end
  end

  it "prints an error when credentials get rejected" do
    fake_cf auth: :rejected do |stdout, stderr|
      command.run('user', 'pass')

      assert_includes stderr.lines, "{auth} Credentials were rejected\n"
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
      fake_cf auth: :fail do
        called = false

        command.run 'user', 'pass' do |logged_in|
          called = true
        end

        refute called, "Expected block to not have been called"
      end
    end
  end
end
