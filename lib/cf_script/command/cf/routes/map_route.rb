module CfScript::Command
  class Routes::MapRouteCommand < CfScript::Command::Base
    def initialize
      super(:routes, :map_route)
    end

    def run(app_name, domain, host = nil, &block)
      options = host ? { n: host } : {}

      run_cf self, app_name, domain, options do |output|
        return false unless can_run?(output,
          check_status: false,
          check_failed: false,
        )

        if output.good? and mapped = output.ok?
          block_given? ? yield(mapped) : mapped
        else
          if output.failed?
            error output.last_line
          else
            error 'failed to map route'
          end

          return false
        end
      end
    end
  end
end
