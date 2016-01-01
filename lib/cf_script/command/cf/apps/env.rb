module CfScript::Command
  class Apps::EnvCommand < CfScript::Command::Base
    def initialize
      super(:apps, :env)
    end

    def run(app_name, &block)
      run_cf self, app_name do |output|
        return {} unless can_run?(output)

        if vars = output.section_attributes('User-Provided')
          block_given? ? yield(vars.to_h) : vars.to_h
        else
          error 'vars is nil'
          return {}
        end
      end
    end
  end
end
