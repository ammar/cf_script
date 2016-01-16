module CfScript::Command
  class Apps::DeleteCommand < CfScript::Command::Base
    def initialize
      super(:apps, :delete)
    end

    def run(app_name, force = false, delete_routes = false, &block)
      options = { flags: [] }

      options[:flags] << :f if force
      options[:flags] << :r if delete_routes

      run_cf self, app_name, options do |output|
        return false unless good_run?(output)

        if output.ok?
          block_given? ? yield(true) : true
        else
          error "failed to delete app"
          return false
        end
      end
    end
  end
end
