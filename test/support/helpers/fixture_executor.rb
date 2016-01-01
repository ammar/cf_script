class FixtureExecutor
  COMMON_FIXTURE_PATH  = "fixtures/common"
  COMMAND_FIXTURE_PATH = "fixtures/commands"

  def initialize(command_fixtures)
    @@fixture_cache ||= {}

    @command_fixtures = command_fixtures
  end

  def execute(env, command_line)
    data = fixture_for(command_line)

    CfScript.stdout.puts if CfScript.config.runtime.trace

    [
      data['stdout'],
      data['stderr'],
      OpenStruct.new(
        exitstatus: data['status']['exitstatus'],
        success?:   data['status']['exitstatus'] == 0
      )
    ]
  end

  private

  def fixture_for(command_line)
    case @command_fixtures[command_line.name]
    when :fail, :no_endpoint, :no_login
      dir = File.join('commands', 'common')
      key = @command_fixtures[command_line.name]
    else
      dir = 'commands'
      key = fixture_key(command_line)
    end

    unless @@fixture_cache.has_key?(key)
      @@fixture_cache[key] = load_fixture(dir, key)
    end

    @@fixture_cache[key]
  end

  def fixture_key(command_line)
    File.join(
      command_line.type.to_s,
      command_line.name.to_s,
      command_fixture(command_line).to_s
    )
  end

  def command_fixture(command_line)
    case command_line.name
    when :target
      if command_line.options[:s]
        command_line.options[:s]
      else
        @command_fixtures[command_line.name] || :good
      end
    else
      @command_fixtures[command_line.name] || :good
    end
  end

  def fixtures_path
    File.expand_path("../../../fixtures", __FILE__)
  end

  def load_fixture(dir, key)
    file = File.join(fixtures_path, dir, "#{key}.yml")

    if File.exist?(file)
      YAML.load(File.new(file, 'r'))
    else
      raise "Missing fixture file `#{file}`"
    end
  end
end
