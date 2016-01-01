require 'test_helper'

describe 'RoutesCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Routes::RoutesCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :routes,
    has_name:  :routes,
    fails_with: nil
  }

  it "returns an Array of RouteInfo objects on success" do
    fake_cf do
      routes = command.run

      assert_instance_of Array, routes
      routes.each do |route|
        assert_instance_of CfScript::RouteInfo, route
      end
    end
  end
end
