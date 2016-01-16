require 'test_helper'

describe 'AppsCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::AppsCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :apps,
    fails_with: CfScript::AppList.new
  }

  it "returns an AppList object" do
    fake_cf do
      apps = command.run

      assert_instance_of CfScript::AppList, apps
      apps.each do |app_info|
        assert_instance_of CfScript::AppInfo, app_info
      end
    end
  end

  it "yields an AppList object when a block is given" do
    fake_cf do
      called = false

      command.run do |apps|
        called = true

        assert_instance_of CfScript::AppList, apps
        apps.each do |app_info|
          assert_instance_of CfScript::AppInfo, app_info
        end
      end

      assert called, "Expected block to have been called"
    end
  end

  it "correctly builds the AppInfo objects" do
    fake_cf do
      apps = command.run

      assert_equal [
        'org-one-api',
        'org-one-worker',
        'org-two-api',
        'org-two-worker'
      ], apps.map(&:name)

      assert_equal [
        'stopped',
        'started',
        'stopped',
        'started'
      ], apps.map(&:requested_state)

      assert_equal ['0/1', '1/3', '0/2', '1/1'], apps.map(&:instances)
      assert_equal ['256M', '1G', '256M', '2G'], apps.map(&:memory)
      assert_equal ['1G', '2G', '3G', '4G'], apps.map(&:disk)

      assert_equal [
        ['example.com', 'example.net'],
        [],
        ['example.io', 'example.org'],
        []
      ], apps.map(&:urls)
    end
  end

  it "returns an empty Array when no apps are found" do
    fake_cf apps: :no_apps do
      apps = command.run

      assert_instance_of CfScript::AppList, apps
      assert_equal CfScript::AppList.new, apps
    end
  end
end
