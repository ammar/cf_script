shared_examples_for 'a command object that' do |attrs|
  it "behaves like a subclass of Command::Base" do
    assert_kind_of CfScript::Command::Base, command

    assert command.respond_to?(:type)
    assert command.respond_to?(:name)
    assert command.respond_to?(:run)

    assert_equal attrs[:has_type], command.type
    assert_equal attrs[:has_name], command.name
  end

  it "returns fail value when run_cf fails (cf's exit status != 0)" do
    fake_cf attrs[:has_name] => :fail do
      args = fake_command_args(command)

      assert_equal attrs[:fails_with], command.run(*args)
    end
  end

  it "prints an error message and returns fail value when an API endpoint is not set" do
    fake_cf attrs[:has_name] => :no_endpoint do |stdout, stderr|
      args = fake_command_args(command)

      assert_equal attrs[:fails_with], command.run(*args)
      assert_includes stderr.lines, "{#{attrs[:has_name]}} No API endpoint set\n"
    end
  end

  it "prints an error message and returns fail value when not logged in" do
    fake_cf attrs[:has_name] => :no_login do |stdout, stderr|
      args = fake_command_args(command)

      assert_equal attrs[:fails_with], command.run(*args)
      assert_includes stderr.lines, "{#{attrs[:has_name]}} Not logged in\n"
    end
  end
end
