require 'test_helper'

describe 'UnmapRouteCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Routes::UnmapRouteCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :routes,
    has_name:  :unmap_route,
    fails_with: false
  }

  it "returns true on success" do
    fake_cf do
      assert_equal true, command.run(:api, 'example.com')
      assert_equal true, command.run(:api, 'example.com', 'api')
    end
  end

  it "prints an error and returns false when the app can not be found" do
    fake_cf unmap_route: :no_app do |stdout, stderr|
      assert_equal false, command.run(:api, 'example.com')

      assert_includes stderr.lines, "{unmap_route} App api not found\n"
    end
  end

  it "prints an error and returns false when the domain can not be found" do
    fake_cf unmap_route: :no_domain do |stdout, stderr|
      assert_equal false, command.run(:api, 'example.com')

      assert_includes stderr.lines, "{unmap_route} Domain example.com not found\n"
    end
  end
end
