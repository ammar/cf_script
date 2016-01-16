require 'test_helper'

describe 'PushCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::PushCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:   :apps,
    has_name:   :push,
    fails_with: nil
  }

  it "returns an AppInfo object on success" do
    fake_cf do
      app_info = command.run(:worker)

      assert_instance_of CfScript::AppInfo, app_info
    end
  end

  it "translates long option names to cf's short ones" do
    fake_cf do
      assert_equal({ f: 'a' }, command.translate_options({ manifest: 'a' }))
      assert_equal({ i: 'a' }, command.translate_options({ instances: 'a' }))
      assert_equal({ m: 'a' }, command.translate_options({ memory: 'a' }))
      assert_equal({ c: 'a' }, command.translate_options({ command: 'a' }))
      assert_equal({ b: 'a' }, command.translate_options({ buildpack: 'a' }))
      assert_equal({ n: 'a' }, command.translate_options({ hostname: 'a' }))
      assert_equal({ d: 'a' }, command.translate_options({ domain: 'a' }))
      assert_equal({ k: 'a' }, command.translate_options({ disk: 'a' }))
      assert_equal({ p: 'a' }, command.translate_options({ path: 'a' }))
      assert_equal({ s: 'a' }, command.translate_options({ stack: 'a' }))
      assert_equal({ t: 'a' }, command.translate_options({ timeout: 'a' }))
      assert_equal({ o: 'a' }, command.translate_options({ docker_image: 'a' }))
      assert_equal({ u: 'a' }, command.translate_options({ health_check_type: 'a' }))

      assert_equal(
        { m: 'b', c: 'a', u: 'd', k: 'c' },
        command.translate_options(
          { command: 'a',  memory: 'b', disk: 'c', health_check_type: 'd' }
        )
      )
    end
  end

  it "builds options and flag for run_cf" do
    assert_command_args command,
      [:worker, i: 2, memory: '123', command: './run', flags: [:no_start]],
      [:worker, { i: 2, m: '123', c: './run', flags: [:no_start] }]
  end
end
