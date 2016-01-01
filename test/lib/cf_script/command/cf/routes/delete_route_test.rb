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
end
