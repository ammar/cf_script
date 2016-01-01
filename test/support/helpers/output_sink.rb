module OutputSink
  module_function

  def start
    CfScript.config.color  = false
    CfScript.config.stdout = StringIO.new
    CfScript.config.stderr = StringIO.new
  end

  def stdout
    CfScript.stdout.string
  end

  def stdout_lines
    stdout.lines.map(&:strip)
  end

  def stderr
    CfScript.stderr.string
  end

  def stderr_lines
    stderr.lines.map(&:strip)
  end
end
