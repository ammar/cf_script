module CfScript::Command
  class Apps::SetEnvCommand < CfScript::Command::Base
    def initialize
      super(:apps, :set_env)
    end

    def run(app_name, var_name, var_value, &block)
      run_cf self, app_name, var_name, var_value do |output|
        return false unless good_run?(output)

        return true if output.contains?("\nOK\n")

        error 'Could not set env variable'
        return false
      end
    end
  end
end
