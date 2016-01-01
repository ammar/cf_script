require 'test_helper'

describe CfScript::Scope do
  subject { CfScript::Scope::Base.new }

  class ScopeTest < CfScript::Scope::Base
    attr_reader :called_enter_scope

    def enter_scope
      @called_enter_scope = true
    end
  end

  it "calls enter_scope on initialize" do
    assert ScopeTest.new.called_enter_scope
  end

  it "responds to finalize which calls exit_scope" do
    assert subject.respond_to?(:finalize)

    subject.stub :exit_scope, 'foo' do
      assert_equal 'foo', subject.finalize
    end
  end

  it "responds to spec_for and calls CfScript.spec_for" do
    assert subject.respond_to?(:spec_for)

    CfScript.stub :spec_for, 'called' do
      assert_equal 'called', subject.spec_for(:app)
    end
  end

  it "responds to method_missing and calls Command.run" do
    assert subject.respond_to?(:method_missing)

    CfScript::Command.stub :run, 'pong' do
      assert_equal 'pong', subject.ping
    end
  end
end
