class CfScript::Command::Error < StandardError
  def initialize(command_line, output)
    super("running '#{command}' [pid: #{output.status.pid}, exit: #{output.status.exitstatus}]")
  end
end
