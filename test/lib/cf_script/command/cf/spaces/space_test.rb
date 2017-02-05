require 'test_helper'

describe 'SpaceCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Spaces::SpaceCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :spaces,
    has_name:  :space,
    fails_with: nil
  }

  it "returns a space object" do
    expected = {
      name:             :staging,
      org:              'ACME',
      apps:             ['org-frontend-staging', 'org-backend-staging'],
      domains:          ['cf.io', 'example.com'],
      services:         ['org-db', 'org-cache'],
      security_groups:  ['ssh', 'dns', 'log'],
    }

    fake_cf do
      space = command.run(:staging)

      expected.keys.each do |key|
        assert_equal expected[key], space.send(key)
      end
    end
  end

  it "returns nil if the output was empty" do
    fake_cf space: :empty do
      space = command.run(:space)

      assert_nil space
    end
  end

  describe "with a block" do
    it "yields a space object" do
      fake_cf space: :good do
        command.run(:staging) do |space|
          assert_respond_to space, :name
          assert_respond_to space, :org
          assert_respond_to space, :apps
          assert_respond_to space, :domains
          assert_respond_to space, :services
          assert_respond_to space, :security_groups
        end
      end
    end
  end
end
