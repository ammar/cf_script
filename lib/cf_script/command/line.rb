require 'shellwords'

class CfScript::Command::Line
  attr_reader :env
  attr_reader :bin
  attr_reader :type
  attr_reader :name
  attr_reader :args
  attr_reader :options
  attr_reader :flags

  def initialize(env, bin, type, name, args = [])
    @env     = env
    @bin     = bin

    @type    = type
    @name    = name
    @options = args.last.is_a?(Hash) ? args.pop : {}
    @flags   = options.delete(:flags) || []
    @args    = args
  end

  def line
    @line ||= format
  end
  alias :to_s :line

  def hide_sensitive
    case name
    when :auth
      hide_parts(-1, 'PASSWORD HIDDEN')
    when :login
      hide_option('-p', 'PASSWORD HIDDEN')
    else
      line
    end
  end

  private

  def format
    list = [bin]

    list << format_name
    list << format_args
    list << format_options
    list << format_flags

    list.compact.reject(&:empty?).join(' ').gsub(/\s+/, ' ')
  end

  def format_name
    name.to_s.gsub(/_/, '-')
  end

  def format_args
    list = []

    args.compact.each do |arg|
      list << arg.to_s.shellescape
    end

    list.join(' ')
  end

  def format_options
    list = []

    options.each do |name, value|
      list << "-#{name} #{value.to_s.shellescape}" unless value.nil?
    end

    list.join(' ')
  end

  def format_flags
    list = []

    flags.each do |name|
      flag = name.to_s.gsub('_', '-')

      list << unless flag =~ /\A(--|-[[:alnum:]])/
        if flag.length == 1
          "-#{flag}"
        else
          "--#{flag}"
        end
      else
        flag
      end
    end

    list.join(' ')
  end

  def hide_parts(parts, with = 'HIDDEN')
    bits = line.split(/\s+(?=(?:[^"']|"[^"]*"|'[^']*')*$)/)
    bits[parts] = "[#{with}]"
    bits.join(' ')
  end

  def hide_option(option, with = 'HIDDEN')
    line.gsub(/#{option}\s+(['"][^'"]+['"]|[\S]+)/, "#{option} [#{with}]")
  end
end
