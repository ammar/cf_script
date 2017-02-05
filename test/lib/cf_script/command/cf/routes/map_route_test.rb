require 'test_helper'

describe 'MapRouteCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Routes::MapRouteCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :routes,
    has_name:  :map_route,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:api, 'example.com')
      assert_equal true, command.run(:api, 'example.com', 'api')
    end
  end

  it "host option defaults to nil" do
    assert_command_args command,
      [:worker, 'example.com'],
      [:worker, 'example.com', {}]
  end

  it "adds option for host when given" do
    assert_command_args command,
      [:worker, 'example.com', 'www'],
      [:worker, 'example.com', { n: 'www' }]
  end

  it "prints an error and returns false when the route is invalid" do
    fake_cf map_route: :invalid do |stdout, stderr|
      assert_equal false, command.run(:api, 'example.com')

      assert_match(/\{map_route\}/, stderr.lines.last)
      assert_match(/Server error/, stderr.lines.last)
      assert_match(/route is invalid/, stderr.lines.last)
    end
  end

  it "prints an error and returns false when the app can not be found" do
    fake_cf map_route: :no_app do |stdout, stderr|
      assert_equal false, command.run(:api, 'example.com')

      assert_includes stderr.lines, "{map_route} App api not found\n"
    end
  end

  it "prints an error and returns false when the domain can not be found" do
    fake_cf map_route: :no_domain do |stdout, stderr|
      assert_equal false, command.run(:api, 'example.com')

      assert_includes stderr.lines, "{map_route} Domain example.com not found\n"
    end
  end

  it "prints an error and returns false when the hostname is taken" do
    fake_cf map_route: :host_taken do |stdout, stderr|
      assert_equal false, command.run(:api, 'example.com')

      assert_match(/\{map_route\}/, stderr.lines.last)
      assert_match(/Server error/, stderr.lines.last)
      assert_match(/The host is taken: api/, stderr.lines.last)
    end
  end
end
