module CfScript::Command
  class Apps::StopCommand < CfScript::Command::Base
    def initialize
      super(:apps, :stop)
    end

    def run(app_name, &block)
      run_cf self, app_name do |output|
        return false unless can_run?(output, check_failed: false)

        if output.ok?
          block_given? ? yield(true) : true
        else
          error "failed to stop"
        end
      end
    end
  end
end
