require 'test_helper'

describe 'RestartCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::RestartCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :apps,
    has_name:  :restart,
    fails_with: nil
  }

  let(:expected_instances) {[
    {
      index:    '#0',
      state:    'running',
      since:    '2015-12-25 00:00:00 AM',
      cpu:      '42.0%',
      memory:   '12.3M of 256M',
      disk:     '45.6M of 1G',
      details:  ''
    }, {
      index:    '#1',
      state:    'stopped',
      since:    '2015-12-25 00:00:00 AM',
      cpu:      '0.0%',
      memory:   '0M of 256M',
      disk:     '45.6M of 1G',
      details:  ''
    },
  ]}

  it "returns an AppStaus object with its instance_status set on success" do
    fake_cf do
      app_info = command.run(:some_app)

      assert_app_info(app_info, expected_instances)
    end
  end

  it "returns nil if no attributes were found" do
    fake_cf restart: :empty do
      result = command.run(:worker)

      assert_nil result
    end
  end

  it "returns nil on failure" do
    fake_cf restart: :not_found do
      assert_nil command.run(:some_app)
    end
  end
end
