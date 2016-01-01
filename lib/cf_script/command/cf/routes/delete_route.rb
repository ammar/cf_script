module CfScript::Command
  class Routes::DeleteRouteCommand < CfScript::Command::Base
    def initialize
      super(:routes, :delete_route)
    end

    def run(domain, host = nil, force = true, &block)
      options = host ? { n: host, flags: [:f] } : { flags: [:f] }

      run_cf self, domain, options do |output|
        return false unless can_run?(output)

        if deleted = output.ok?
          block_given? ? yield(deleted) : deleted
        end
      end
    end
  end
end
