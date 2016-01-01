require 'test_helper'

describe 'TargetCommand' do
  include MockExecution

  let(:command) { CfScript::Command::General::TargetCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :general,
    has_name:  :target,
    fails_with: nil
  }

  it "returns nil and prints an error on parsing failure" do
    fake_cf target: :empty do |stdout, stderr|
      assert_equal nil, command.run

      assert_includes stderr.lines, "{target} object is nil\n"
    end
  end

  describe "without an argument" do
    it "returns the current target's attributes" do
      expected = {
        api_endpoint: 'https://api.cf.io (API version: 1.0.0)',
        org:          'ACME',
        user:         'user@example.com',
        space:        'development'
      }

      fake_cf target: :good do
        target = command.run

        expected.keys.each do |key|
          assert_equal expected[key], target.send(key)
        end
      end
    end

    it "returns a blank space name when there isn't a current one targeted" do
      expected = {
        api_endpoint: 'https://api.cf.io (API version: 1.0.0)',
        org:          'ACME',
        user:         'user@example.com',
        space:        ''
      }

      fake_cf target: :no_space do |stdout, stderr|
        target = command.run

        expected.keys.each do |key|
          assert_equal expected[key], target.send(key)
        end
      end
    end
  end

  describe "with an argument" do
    it "returns the target attributes for the given space" do
      expected = {
        api_endpoint: 'https://api.cf.io (API version: 1.0.0)',
        org:          'ACME',
        user:         'user@example.com',
        space:        'staging'
      }

      fake_cf target: :staging do
        target = command.run(:staging)

        expected.keys.each do |key|
          assert_equal expected[key], target.send(key)
        end
      end
    end

    it "returns nil and prints an error when the space is not found" do
      fake_cf do |stdout, stderr|
        assert_equal nil, command.run(:not_found)

        assert_includes stderr.lines, "{target} Space not_found not found\n"
      end
    end
  end

  describe "without a block" do
    it "returns an object with the target's attributes" do
      fake_cf target: :good do
        target = command.run

        assert_respond_to target, :api_endpoint
        assert_respond_to target, :org
        assert_respond_to target, :user
        assert_respond_to target, :space
      end
    end
  end

  describe "with a block" do
    it "yields an object with the target's attributes" do
      fake_cf target: :good do |stdout, stderr|
        command.run do |target|
          assert_respond_to target, :api_endpoint
          assert_respond_to target, :org
          assert_respond_to target, :user
          assert_respond_to target, :space
        end
      end
    end
  end
end
