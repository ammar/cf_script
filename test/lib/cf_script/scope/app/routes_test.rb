require 'test_helper'

describe CfScript::Scope::App::Routes do
  include MockExecution

  let(:target) { CfScript::Target.new('API', 'ORG', 'staging') }

  def create_app(name)
    app = nil
    fake_cf { app = CfScript::Scope::App.new(:api, target) }
    app
  end

  it "defines a has_route? method" do
    app = create_app(:api)

    app.stub :urls, ['api.example.com'] do
      assert_equal false, app.has_route?('www.example.com')
      assert_equal true,  app.has_route?('api.example.com')
    end
  end

  it "defines a map_route method that calls Command.map_route with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :map_route, command
      assert_equal [:api, 'domain', nil], args

      return :called
    end

    app.stub :cf_self, true do
      CfScript::Command.stub :run, arg_catcher do
        assert_equal :called, app.map_route('domain')
      end
    end
  end

  it "defines an unmap_route method that calls Command.unmap_route with the app name" do
    app = create_app(:api)

    arg_catcher = lambda do |command, *args, &block|
      assert_equal :unmap_route, command
      assert_equal [:api, 'domain', nil], args

      return :called
    end

    app.stub :cf_self, true do
      CfScript::Command.stub :run, arg_catcher do
        assert_equal :called, app.unmap_route('domain')
      end
    end
  end
end
