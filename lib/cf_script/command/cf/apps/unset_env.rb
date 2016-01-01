module CfScript::Command
  class Apps::UnsetEnvCommand < CfScript::Command::Base
    def initialize
      super(:apps, :unset_env)
    end

    def run(app_name, var_name, &block)
      run_cf self, app_name, var_name do |output|
        return false unless can_run?(output)

        return true if output.contains?("\nOK\n")

        error 'Could not unset env variable'
        return false
      end
    end
  end
end
