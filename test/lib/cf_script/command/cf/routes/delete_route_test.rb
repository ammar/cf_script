require 'test_helper'

describe 'DeleteRouteCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Routes::DeleteRouteCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :routes,
    has_name:  :delete_route,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run('example.com', :api)
    end
  end

  it "adds flag for force by default" do
    assert_command_args command,
      ['example.com'],
      ['example.com', { flags: [:f] }]
  end

  it "skips flag for force when false" do
    assert_command_args command,
      ['example.com', 'www', false],
      ['example.com', { n: 'www' }]
  end

  it "adds option for host and flag for force when both are given" do
    assert_command_args command,
      ['example.com', 'www', true],
      ['example.com', { n: 'www', flags: [:f] }]
  end
end
