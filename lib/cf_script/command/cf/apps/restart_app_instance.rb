module CfScript::Command
  class Apps::RestartAppInstanceCommand < CfScript::Command::Apps::Base
    def initialize
      super(:apps, :restart_app_instance)
    end

    def run(app_name, instance_index, &block)
      run_cf self, app_name, instance_index do |output|
        return false unless good_run?(output, check_failed: false)

        if output.ok?
          block_given? ? yield(true) : true
        else
          error "failed to restart app instance #{instance_index}"
          return false
        end
      end
    end
  end
end
