class ConfigContext
  def initialize
    @stdout   = CfScript.config.io.stdout
    @stderr   = CfScript.config.io.stderr

    @color    = CfScript.config.ui.color

    @executor = CfScript.config.runtime.executor
  end

  def reset
    CfScript.config.io.stdout = @stdout
    CfScript.config.io.stderr = @stderr

    CfScript.config.ui.color = @color

    CfScript.config.runtime.executor = @executor
  end
end
