module CfScript::Command
  class Routes::UnmapRouteCommand < CfScript::Command::Base
    def initialize
      super(:routes, :unmap_route)
    end

    def run(app_name, domain, host = nil, &block)
      options = host ? { n: host } : {}

      run_cf self, app_name, domain, options do |output|
        return false unless good_run?(output,
          check_status: false,
          check_failed: false,
        )

        if output.good? and unmapped = output.ok?
          block_given? ? yield(unmapped) : unmapped
        else
          if output.failed?
            error output.last_line
          else
            error 'failed to unmap route'
          end

          return false
        end
      end
    end
  end
end
