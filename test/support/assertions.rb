def assert_app_info(app_info, expected_instances)
  assert_instance_of CfScript::AppInfo, app_info

  assert_instance_of Array, app_info.instance_status
  assert_equal expected_instances.length, app_info.instance_status.length

  app_info.instance_status.each_with_index do |instance_status, index|
    assert_instance_of CfScript::InstanceStatus, instance_status

    expected_instances[index].each do |attr, value|
      assert_equal value, instance_status.send(attr)
    end
  end
end

# Asserts that a command correctly prepares its arguments for passing to
# run_cf and in turn to the cf binary. call_args is an array of the args
# to be passed to the command's run method, and run_args is an array of
# the args expected to be passed to run_cf.
def assert_command_args(command, call_args, run_args)
  output = CfScript::Output.new(command, '', '',
    OpenStruct.new(
      exitstatus: 0,
      success?:   true,
    )
  )

  arg_catcher = lambda do |cmd, *args, &block|
    assert_equal run_args, args
  end

  fake_cf do
    command.stub :run_cf, arg_catcher, output do
      command.stub :good_run?, true do
        command.run(*call_args)
      end
    end
  end
end
