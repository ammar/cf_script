require 'test_helper'

describe CfScript::ApiEndpoint do
  subject { CfScript::ApiEndpoint }

  it "initializes all attributes to sensible defaults" do
    api_endpoint = subject.new

    assert_equal nil, api_endpoint.url
    assert_equal nil, api_endpoint.version
  end

  it "sets all given attributes" do
    api_endpoint = subject.new('URL', '123')

    assert_equal 'URL', api_endpoint.url
    assert_equal '123', api_endpoint.version
  end
end
