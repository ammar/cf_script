module CfScript::Command
  class Routes::CheckRouteCommand < CfScript::Command::Base
    def initialize
      super(:routes, :check_route)
    end

    def run(host, domain, &block)
      run_cf self, host, domain do |output|
        return false unless can_run?(output)

        exists = output.matches? /^Route #{host}.#{domain} does exist/

        block_given? ? yield(exists) : exists
      end
    end
  end
end
