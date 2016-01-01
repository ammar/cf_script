require 'open3'

class CfScript::Executor::Simple
  def initialize
    @executions = 0
  end

  def execute(env, command_line)
    @executions += 1

    out, err, status = Open3.capture3(env, command_line.to_s)

    puts if CfScript.config.runtime.trace

    [out, err, status]
  end
end
