require 'test_helper'

describe 'ScaleCommand' do
  include MockExecution

  let(:command) { CfScript::Command::Apps::ScaleCommand.instance }

  it_behaves_like 'a command object that', {
    has_type:   :apps,
    has_name:   :scale,
    fails_with: nil
  }

  it "returns true on success" do
    fake_cf do
      result = command.run(:worker)

      assert_instance_of TrueClass, result
    end
  end

  it "returns false if no attributes were found" do
    fake_cf scale: :empty do
      result = command.run(:api)

      assert_equal false, result
    end
  end

  it "translates long option names to cf's short ones" do
    fake_cf do
      assert_equal({ f: 'a' }, command.translate_options({ force_restart: 'a' }))
      assert_equal({ i: 'a' }, command.translate_options({ instances: 'a' }))
      assert_equal({ m: 'a' }, command.translate_options({ memory: 'a' }))
      assert_equal({ k: 'a' }, command.translate_options({ disk: 'a' }))

      assert_equal(
        { i: 'a', m: 'b', k: 'c' },
        command.translate_options(
          { instances: 'a',  memory: 'b', disk: 'c' }
        )
      )
    end
  end

  it "builds options and flag for run_cf" do
    assert_command_args command,
      [:worker, i: 2, memory: '123', disk: '345'],
      [:worker, { i: 2, m: '123', k: '345' }]
  end
end
