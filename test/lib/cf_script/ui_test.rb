require 'test_helper'

describe CfScript::UI do
  include MockExecution

  subject { CfScript::UI }

  it "defines a puts_out method that outputs to the configured stdout" do
    fake_io do |out, err|
      subject.puts_out 'foo bar'

      assert_equal "foo bar\n", out.lines.first
      assert_equal true, err.lines.empty?
    end
  end

  it "defines a print_out method that outputs to the configured stdout" do
    fake_io do |out, err|
      subject.print_out 'foo bar'

      assert_equal "foo bar", out.lines.first
      assert_equal true, err.lines.empty?
    end
  end

  it "defines a puts_err method that outputs to the configured stderr" do
    fake_io do |out, err|
      subject.puts_err 'foo bar'

      assert_equal true, out.lines.empty?
      assert_equal "foo bar\n", err.lines.first
    end
  end

  it "defines a print_err method that outputs to the configured stderr" do
    fake_io do |out, err|
      subject.print_err 'foo bar'

      assert_equal true, out.lines.empty?
      assert_equal "foo bar", err.lines.first
    end
  end

  describe "with_color_of" do
    it "returns default color by default" do
      color = subject.with_color_of

      assert_equal({ color: :default }, color)
    end

    it "returns color for given type" do
      color = subject.with_color_of(:error)

      assert_equal({ color: :red }, color)
    end
  end

  describe "tag_char" do
    it "returns default character for unknown type" do
      char = subject.tag_char(:bogus, :first)

      assert_equal '[', char
    end

    it "returns character for given type" do
      char = subject.tag_char(:error, :last)

      assert_equal '}', char
    end
  end

  describe "tag_open/tag_close" do
    it "return first and last characters for type" do
      open_char  = subject.tag_open(:other)
      close_char = subject.tag_close(:other)

      assert_equal '[', open_char
      assert_equal ']', close_char
    end
  end

  describe "emoji_for" do
    it "returns nil if config.ui.emoji is false" do
      with_config do
        emoji = subject.emoji_for(:success)

        assert_equal nil, emoji
      end
    end

    it "returns emoji character if config.ui.emoji is true" do
      with_config emoji: true do
        emoji = subject.emoji_for(:success)

        assert_equal [9989, 32], emoji.codepoints
      end
    end
  end

  describe "tag_format" do
    it "returns nil if config.ui.tags is false" do
      with_config tags: false do
        tag = subject.tag_format('foo', :trace)

        assert_equal nil, tag
      end
    end

    it "returns nil if the tag is nil" do
      with_config tags: true do
        tag = subject.tag_format(nil, :trace)

        assert_equal nil, tag
      end
    end

    it "returns formatted tag if tag is given and config.ui.tags is true" do
      with_config tags: true, color: true do
        tag = subject.tag_format('foo', :trace)

        assert_equal "\e[0;90;49m<foo>\e[0m", tag
      end
    end
  end

  describe "ui_format" do
    it "returns a formatted message" do
      text = subject.ui_format(:success, 'foo', 'bar')

      assert_equal "\e[0;32;49m[foo]\e[0m \e[0;32;49mbar\e[0m", text
    end
  end
end
