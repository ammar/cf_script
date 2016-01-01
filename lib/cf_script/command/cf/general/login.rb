module CfScript::Command::General
  class LoginCommand < CfScript::Command::Base
    def initialize
      super(:general, :login)
    end

    def run(username, password, options = {}, &block)
      args = [{ u: username, p: password }]

      if options[:api]
        args.last[:a] = options[:api]
      end

      if options[:org]
        args.last[:o] = options[:org]
      end

      if options[:space]
        args.last[:s] = options[:space]
      end

      run_cf self, *args do |output|
        unless can_run?(output, check_failed: false)
          if output.credentials_rejected?
            error 'Credentials were rejected'
          else
            output.dump
          end

          return false
        else
          if logged_in = output.authenticated?
            block_given? ? yield(logged_in) : logged_in
          else
            error 'Not logged in'
            return false
          end
        end
      end
    end
  end
end
