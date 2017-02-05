require 'test_helper'

describe CfScript::Target do
  subject { CfScript::Target }

  it "initializes all attributes to sensible defaults" do
    target = subject.new

    assert_equal '', target.api_endpoint
    assert_equal '', target.org
    assert_equal '', target.space
    assert_nil   target.user
  end

  describe "to_options" do
    it "returns an empty Hash when org and space are not set" do
      options = subject.new.to_options

      assert_instance_of Hash, options
      assert_equal({}, options)
    end

    it "returns a Hash with org and space when set" do
      options = subject.new('api', 'ORG', 'SPACE', 'user@example.com').to_options

      assert_equal({ o: 'ORG', s: 'SPACE' }, options)
    end

    it "returns a Hash with org when set" do
      options = subject.new('api', 'ORG').to_options

      assert_equal({ o: 'ORG' }, options)
    end

    it "returns a Hash with the space when set" do
      options = subject.new('api', '', 'SPACE').to_options

      assert_equal({ s: 'SPACE' }, options)
    end
  end
end
