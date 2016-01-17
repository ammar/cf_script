module MockExecution
  module_function

  def test_env
    ENV['CF_BINARY'] = 'cf'
  end

  def test_config(options = {})
    CfScript.config.io.stdout = options[:stderr] || StringIO.new
    CfScript.config.io.stderr = options[:stderr] || StringIO.new

    CfScript.config.ui.tags  = options.key?(:tags)  ? options[:tags]  : true
    CfScript.config.ui.color = options.key?(:color) ? options[:color] : false
    CfScript.config.ui.emoji = options.key?(:emoji) ? options[:emoji] : false

    CfScript.config.runtime.trace = options.key?(:trace) ? options[:trace] : true
  end

  def with_config(config_options = {}, &block)
    config_context = ConfigContext.new

    test_config(config_options)

    yield
  ensure
    config_context.reset
  end

  def test_executor(executor)
    CfScript.config.runtime.executor = executor
  end

  def fake_process_status(exitstatus = 0)
    OpenStruct.new(
      exitstatus: exitstatus,
      success?:   exitstatus == 0
    )
  end

  def fake_output(out = '', err = '', exitstatus = 0)
    command = CfScript::Command::General::TargetCommand.instance
    stdout  = out
    stderr  = err
    status  = fake_process_status(exitstatus)

    CfScript::Output.new(command, stdout, stderr, status)
  end

  def fake_command_args(command)
    arity = command.method(:run).arity

    if arity == -1
      []
    else
      ([:arg] * (arity.abs - 1)) + [{}]
    end
  end

  def fake_io(config_options = {}, &block)
    config_context = ConfigContext.new

    test_config(config_options)

    yield(CfScript.stdout.string, CfScript.stderr.string)
  ensure
    config_context.reset
  end

  def fake_cf(command_fixtures = {}, &block)
    config_context = ConfigContext.new

    test_env
    test_config
    test_executor FixtureExecutor.new(command_fixtures)

    yield(CfScript.stdout.string, CfScript.stderr.string)
  ensure
    config_context.reset
  end
end
