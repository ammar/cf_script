module CfScript::Command
  class Apps::AppCommand < CfScript::Command::Apps::Base
    def initialize
      super(:apps, :app)
    end

    def run(app_name, options = {}, &block)
      run_cf self, app_name do |output|
        return nil unless good_run?(output)

        if app_info = build_app_info(app_name, output)
          block_given? ? yield(app_info) : app_info
        else
          error 'attributes is nil'
        end
      end
    end
  end
end
