module CfScript::Command
  class Routes::CreateRouteCommand < CfScript::Command::Base
    def initialize
      super(:routes, :create_route)
    end

    def run(space, domain, host = nil, &block)
      options = host ? { n: host } : {}

      run_cf self, space, domain, options do |output|
        return false unless can_run?(output)

        if exists = output.contains?(/^OK$/)
          block_given? ? yield(exists) : exists
        end
      end
    end
  end
end
