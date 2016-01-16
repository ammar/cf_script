module CfScript::Command
  class Apps::RestartCommand < CfScript::Command::Apps::Base
    def initialize
      super(:apps, :restart)
    end

    def run(app_name, &block)
      run_cf self, app_name do |output|
        return unless good_run?(output)

        if app = build_app_info(app_name, output)
          block_given? ? yield(app) : app
        else
          error "app is nil"
        end
      end
    end
  end
end
