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
