require 'test_helper'

describe CfScript::Command::Line do
  subject { CfScript::Command::Line }

  it "initializes bin, name, args, options, and flags" do
    line = subject.new({ foo: :bar }, 'bin', :test, :dummy,
      [:arg1, :arg2, { i: 1, o: 2, flags: [:s] }]
    )

    assert_equal 'bin',          line.bin
    assert_equal :dummy,         line.name
    assert_equal [:arg1, :arg2], line.args
    assert_equal({ i: 1, o: 2 }, line.options)
    assert_equal [:s],           line.flags
  end

  describe "line" do
    it "returns a formatted command line" do
      line = subject.new({}, 'cf', :test, :dummy,
        [:arg1, :arg2, { i: 1, o: 2, flags: [:s] }]
      )

      assert_equal 'cf dummy arg1 arg2 -i 1 -o 2 -s', line.line
    end

    it "formats long flag names" do
      line = subject.new({}, 'cf', :test, :dummy,
        [:arg1, { i: 1, flags: [:some_thing] }]
      )

      assert_equal 'cf dummy arg1 -i 1 --some-thing', line.line
    end

    it "pass preformatted flags as is" do
      line = subject.new({}, 'cf', :test, :dummy,
        [:arg1, { i: 1, flags: ['--one', '--foo-bar'] }]
      )

      assert_equal 'cf dummy arg1 -i 1 --one --foo-bar', line.line
    end
  end

  it "hides password for auth command" do
    line = subject.new({}, 'cf', :test, :auth, ['username', 'password'])

    assert_equal 'cf auth username [PASSWORD HIDDEN]', line.hide_sensitive
  end

  it "hides password for login command" do
    options = [
      { p: 'word', u: 'name', a: 'work' },
      { u: 'name', p: 'word', a: 'work' },
      { u: 'name', a: 'work', p: 'word' },
    ]

    options.each do |test|
      line = subject.new({}, 'cf', :test, :login, [test])
      text = line.hide_sensitive

      assert_match(/cf login /, text)
      assert_match(/-p \[PASSWORD HIDDEN\]/, text)
      assert_match(/-u name/, text)
      assert_match(/-a work/, text)
    end
  end
end
