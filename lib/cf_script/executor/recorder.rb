class CfScript::Executor::Recorder
  def initialize(executor = nil)
    @executions = []
    @executor   = executor || CfScript::Executor::Simple.new
  end

  def execute(env, command_line)
    @executions << command_line

    @executor.execute(env, command_line)
  end

  def dump
    puts @executions.join("\n")
  end
end
