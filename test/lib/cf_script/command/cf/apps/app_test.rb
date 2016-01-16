require 'test_helper'

describe 'AppCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::AppCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :app,
    fails_with: nil
  }

  it "returns an App object" do
    fake_cf do
      app = command.run(:frontend)

      assert_kind_of CfScript::AppInfo, app
    end
  end

  it "yields an App object when a block is given" do
    fake_cf do
      called = false

      command.run(:worker) do |app|
        called = true

        assert_kind_of CfScript::AppInfo, app
      end

      assert called, "Expected block to have been called"
    end
  end

  it "returns nil if no attributes were found" do
    fake_cf app: :empty do
      result = command.run(:worker)

      assert_equal nil, result
    end
  end

  it "returns nil when the app is not found" do
    fake_cf app: :not_found do
      assert_equal nil, command.run(:api)
    end
  end

  it "includes status line" do
    fake_cf app: :running do |stdout, srderr|
      app = command.run(:frontend)

      assert_kind_of CfScript::AppInfo, app

      assert_instance_of Array, app.instance_status
      assert_equal 1, app.instance_status.length

      app.instance_status.each do |instance_status|
        assert_instance_of CfScript::InstanceStatus, instance_status
      end
    end
  end
end
