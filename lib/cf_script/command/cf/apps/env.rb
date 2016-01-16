module CfScript::Command
  class Apps::EnvCommand < CfScript::Command::Base
    def initialize
      super(:apps, :env)
    end

    def run(app_name, &block)
      run_cf self, app_name do |output|
        return {} unless good_run?(output)

        if vars = output.section_attributes('User-Provided')
          block_given? ? yield(vars.to_h) : vars.to_h
        elsif output.contains?('No user-defined env variables have been set')
          return {}
        else
          error 'could not get environment variables'
          return {}
        end
      end
    end
  end
end
