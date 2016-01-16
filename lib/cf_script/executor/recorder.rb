class CfScript::Executor::Recorder
  attr_reader :executions

  def initialize(executor = nil)
    @executions = []
    @executor   = executor || CfScript.config.runtime.executor
  end

  def execute(env, command_line)
    @executions << command_line

    @executor.execute(env, command_line)
  end

  def dump
    puts @executions.join("\n")
  end
end
