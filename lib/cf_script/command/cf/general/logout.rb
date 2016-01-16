module CfScript::Command::General
  class LogoutCommand < CfScript::Command::Base
    def initialize
      super(:general, :logout)
    end

    def run(*args, &block)
      run_cf self, *args do |output|
        return false unless good_run?(output)

        block_given? ? yield(output.ok?) : output.ok?
      end
    end
  end
end
