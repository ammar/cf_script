require 'test_helper'

describe 'CreateRouteCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Routes::CreateRouteCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :routes,
    has_name:  :create_route,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:staging, :api, 'example.com')
    end
  end
end
