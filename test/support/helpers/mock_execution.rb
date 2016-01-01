module MockExecution
  module_function

  def test_env
    ENV['CF_BINARY'] = 'cf'
  end

  def test_config(config = {})
    CfScript.config.io.stdout     = config[:stderr] || StringIO.new
    CfScript.config.io.stderr     = config[:stderr] || StringIO.new

    CfScript.config.ui.color      = config[:color]  || false

    CfScript.config.runtime.trace = config[:trace]  || true
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

  def fake_cf(command_fixtures = {}, &block)
    config = ConfigContext.new

    test_env
    test_config
    test_executor FixtureExecutor.new(command_fixtures)

    yield(CfScript.stdout.string, CfScript.stderr.string)
  ensure
    config.reset
  end
end
