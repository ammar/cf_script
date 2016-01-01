# encoding: utf-8

require 'colorize'

module CfScript::UI
  TAGS = {
    error: ['{', '}'],
    trace: ['<', '>'],
    debug: ['(', ')'],
    other: ['[', ']'],
  }

  COLORS = {
    success:  { color: :green },
    error:    { color: :red },
    alert:    { color: :yellow },
    info:     { color: :cyan },

    inactive: { color: :light_red },
    active:   { color: :light_green },

    progress: { color: :blue },
    step:     { color: :light_blue },

    title:    { color: :magenta },
    detail:   { color: :light_magenta },

    trace:    { color: :light_black },
    debug:    { color: :white },

    # NOTE: default != no color
    default:  { color: :default },
  }

  EMOJI = {
    success:  "\xE2\x9C\x85",
    error:    "\xE2\x9D\x8C",
    alert:    "\xE2\x9A\xA1",
    info:     "\xE2\x9D\x95",

    trace:    "\xE2\x86\xAA",
    debug:    "\xE2\x9A\xAA",

    default:  "\xE2\x9E\x96",

    bisque:   "🍲",
  }

  module_function

  def puts_out(text)
    CfScript.stdout.puts text
    nil # Make it explicit
  end

  def print_out(text)
    CfScript.stdout.print text
    nil # Make it explicit
  end

  def puts_err(text)
    CfScript.stderr.puts text
    nil # Make it explicit
  end

  def print_err(text)
    CfScript.stderr.print text
    nil # Make it explicit
  end

  def with_color_of(type = :default)
    COLORS[CfScript.config.ui.color ? type : :default]
  end

  def ui_style(text, type = :default)
    text.colorize with_color_of(type)
  end

  def emoji(type)
    "#{(EMOJI.key?(type) ? EMOJI[type] : EMOJI[:default])} "
  end

  def emoji_for(type)
    emoji(type) if CfScript.config.ui.emoji
  end

  def tag_style(type = :default)
    type
  end

  def tag_color(type = :default)
    type
  end

  def tag_char(type, which)
    (TAGS.key?(type) ? TAGS[type] : TAGS[:other]).send(which)
  end

  def tag_open(type = :default)
    tag_char(tag_style(type), :first)
  end

  def tag_close(type = :default)
    tag_char(tag_style(type), :last)
  end

  def tag_format(tag, type = :default)
    if tag and CfScript.config.ui.tags
      list = []

      list << tag_open(type)
      list << tag
      list << tag_close(type)

      list.join.colorize with_color_of(tag_color(type))
    end
  end

  def ui_format(type, tag, message, tag_type = nil)
    list = []

    list << emoji_for(type)
    list << tag_format(tag, tag_type ? tag_type : type)
    list << message.colorize(with_color_of(type))

    list.compact.reject(&:empty?).join(' ')
  end

  def call_type(callee)
    callee.to_s =~ /\Aui_(.+)\z/ ? $1.to_sym : callee
  end

  def success(tag, message)
    puts_out ui_format(call_type(__callee__), tag, message)
  end

  def error(tag, message)
    puts_err ui_format(call_type(__callee__), tag, message)
  end

  def alert(tag, message)
    puts_out ui_format(call_type(__callee__), tag, message)
  end

  def info(tag, message)
    puts_out ui_format(call_type(__callee__), tag, message)
  end

  def progress(tag, message)
    puts_out ui_format(call_type(__callee__), tag, message)
  end

  def step(tag, message)
    puts_out ui_format(call_type(__callee__), tag, message)
  end

  def title(tag, message, indent = 0)
    puts_out ui_format(call_type(__callee__), tag, "#{'  ' * indent}#{message}")
  end

  def detail(tag, message, indent = 1)
    puts_out ui_format(call_type(__callee__), tag, "#{'  ' * indent}#{message}")
  end

  def trace(tag, message, use_print = false)
    if CfScript.config.runtime.trace
      text = ui_format(call_type(__callee__), tag, message)
      use_print ? print_out(text) : puts_out(text)
    end
  end

  def debug(tag, message)
    puts_err ui_format(call_type(__callee__), tag, message.inspect)
   #binding.pry; __pry__.???
  end

  # For overriding to use a default tag
  alias :ui_tag_format :tag_format
  alias :ui_success :success
  alias :ui_error :error
  alias :ui_alert :alert
  alias :ui_info :info
  alias :ui_progress :progress
  alias :ui_step :step
  alias :ui_title :title
  alias :ui_detail :detail
  alias :ui_trace :trace
  alias :ui_debug :debug
end

module CfScript::UI::NilTag
  def success(message)
    ui_success nil, message
  end

  def error(message)
    ui_error nil, message
  end

  def alert(message)
    ui_alert nil, message
  end

  def info(message)
    ui_info nil, message
  end

  def progress(message)
    ui_progress nil, message
  end

  def step(message)
    ui_step nil, message
  end

  def title(message, indent = 0)
    ui_title nil, message, indent
  end

  def detail(message, indent = 1)
    ui_detail nil, message, indent
  end
end

module CfScript::UI::NameTag
  def name_tag
    name
  end

  def success(message)
    ui_success name_tag, message
  end

  def error(message)
    ui_error name_tag, message
  end

  def alert(message)
    ui_alert name_tag, message
  end

  def info(message)
    ui_info name_tag, message
  end

  def progress(message)
    ui_progress name_tag, message
  end

  def step(message)
    ui_step name_tag, message
  end

  def title(message, indent = 0)
    ui_title name_tag, message, indent
  end

  def detail(message, indent = 1)
    ui_detail name_tag, message, indent
  end
end
