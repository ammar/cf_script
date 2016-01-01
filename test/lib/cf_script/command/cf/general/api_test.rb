require 'test_helper'

describe 'ApiCommand' do
  include MockExecution

  let(:command) { CfScript::Command::General::ApiCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :general,
    has_name:  :api,
    fails_with: nil
  }

  describe "without an argument" do
    it "returns the current api endpoint" do
      fake_cf api: :good do |stdout, stderr|
        endpoint = command.run

        assert_instance_of CfScript::ApiEndpoint, endpoint
        assert_equal 'https://api.cf.io', endpoint.url
        assert_equal '1.0.0', endpoint.version
      end
    end

    it "returns nil when the api endpoint is not set" do
      fake_cf api: :not_set do |stdout, stderr|
        assert_equal nil, command.run
      end
    end
  end

  describe "with an argument" do
    it "sets the current api endpoint and returns its object" do
      fake_cf api: :set do |stdout, stderr|
        endpoint = command.run 'https://api.test.com'

        assert_instance_of CfScript::ApiEndpoint, endpoint
        assert_equal 'https://api.test.com', endpoint.url
        assert_equal '1.2.3', endpoint.version
      end
    end

    it "returns nil when the argument is invalid" do
      fake_cf api: :bad_argument do |stdout, stderr|
        assert_equal nil, command.run('')
      end
    end

    it "returns nil when the endpoint is invalid" do
      fake_cf api: :bad_endpoint do |stdout, stderr|
        assert_equal nil, command.run('https://api.example.com')
      end
    end
  end
end
