require 'test_helper'

describe CfScript::Command::Base do
  include MockExecution

  class TestCommand < CfScript::Command::Base
    def initialize
      super(:test, :dummy)
    end
  end

  subject { TestCommand.instance }

  it "defines a line method that returns a Command::Line object" do
    line = subject.line({}, 'cf', [])

    assert_instance_of CfScript::Command::Line, line
  end

  it "raises an exception if run is called" do
    assert_raises(RuntimeError) {
      subject.run
    }
  end

  describe "option_value" do
    it "returns option value if present" do
      options = { test: true }

      result = subject.option_value(options, :test, false)

      assert_equal true, result
    end

    it "returns default value if option is not present" do
      options = {}

      result = subject.option_value(options, :test, false)

      assert_equal false, result
    end
  end

  describe "good_run?" do
    describe "exit status is zero" do
      it "returns true" do
        output = fake_output

        assert_equal true, subject.good_run?(output)
      end
    end

    describe "exit status is not zero" do
      before { @output = fake_output('', '', 1) }

      it "returns false" do
        fake_io do |stdout, stderr|
          assert_equal false, subject.good_run?(@output)
        end
      end

      it "prints an error message" do
        fake_io do |stdout, stderr|
          subject.good_run?(@output)

          assert_match(/\{dummy\}/, stderr.lines.last)
          assert_match(/cf exited with error/, stderr.lines.last)
        end
      end

      describe "and check_status is false" do
        it "returns true" do
          fake_io do |stdout, stderr|
            result = subject.good_run?(@output, check_status: false)

            assert_equal true, result
          end
        end

        it "doesn't print an error message" do
          fake_io do |stdout, stderr|
            subject.good_run?(@output, check_status: false)

            assert_equal 0, stderr.lines.length
          end
        end
      end
    end

    describe "output contains FAILED" do
      before { @output = fake_output('FAILED') }

      it "returns false" do
        fake_io do |stdout, stderr|
          assert_equal false, subject.good_run?(@output)
        end
      end

      it "returns true when check_failed is false" do
        fake_io do |stdout, stderr|
          result = subject.good_run?(@output, check_failed: false)

          assert_equal true, result
        end
      end
    end

    describe "output contains 'No API endpoint set'" do
      before { @output = fake_output('No API endpoint set') }

      it "returns false" do
        fake_io do |stdout, stderr|
          assert_equal false, subject.good_run?(@output)
        end
      end

      it "prints an error message" do
        fake_io do |stdout, stderr|
          subject.good_run?(@output)

          assert_match(/\{dummy\}/, stderr.lines.last)
          assert_match(/No API endpoint set/, stderr.lines.last)
        end
      end
    end

    describe "output contains 'Not logged in'" do
      before { @output = fake_output('Not logged in') }

      it "returns false" do
        fake_io do |stdout, stderr|
          assert_equal false, subject.good_run?(@output)
        end
      end

      it "prints an error message" do
        fake_io do |stdout, stderr|
          subject.good_run?(@output)

          assert_match(/\{dummy\}/, stderr.lines.last)
          assert_match(/Not logged in/, stderr.lines.last)
        end
      end
    end
  end
end
