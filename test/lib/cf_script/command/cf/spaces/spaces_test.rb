require 'test_helper'

describe 'SpacesCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Spaces::SpacesCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:  :spaces,
    has_name:  :spaces,
    fails_with: nil
  }

  it "returns an Array of space names" do
    fake_cf spaces: :good do
      spaces = command.run

      assert_kind_of Array, spaces
      assert_equal ['development', 'staging', 'production'], spaces
    end
  end

  it "returns nil if the spaces table was not found" do
    fake_cf spaces: :empty do
      spaces = command.run

      assert_nil spaces
    end
  end

  it "yields an Array of space names when a block is given" do
    fake_cf do
      called = false

      command.run do |spaces|
        called = true

        assert_kind_of Array, spaces
        spaces.each do |space_name|
          assert_includes ['development', 'staging', 'production'], space_name
        end
      end

      assert called, "Expected block to have been called"
    end
  end
end
