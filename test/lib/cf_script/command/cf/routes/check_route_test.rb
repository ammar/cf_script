require 'test_helper'

describe 'CheckRouteCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Routes::CheckRouteCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :routes,
    has_name:  :check_route,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run('api', 'example.com')
    end
  end

  it "returns false when the route does not exist" do
    fake_cf check_route: :no_route do
      assert_equal false, command.run('api', 'example.com')
    end
  end

  it "returns false when the domain does not exist" do
    fake_cf check_route: :no_domain do
      assert_equal false, command.run('api', 'example.com')
    end
  end
end
