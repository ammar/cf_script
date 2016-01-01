module CfScript::Scope
  module App::Env
    def env
      CfScript::Command.env name
    end

    def set_env(var_name, var_value)
      CfScript::Command.set_env name, var_name, var_value
    end

    def unset_env(var_name)
      CfScript::Command.unset_env name, var_name
    end
  end
end
