module CfScript::Command::General
  class AuthCommand < CfScript::Command::Base
    def initialize
      super(:general, :auth)
    end

    def run(username, password, &block)
      run_cf self, username, password do |output|
        unless good_run?(output, check_failed: false)
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
