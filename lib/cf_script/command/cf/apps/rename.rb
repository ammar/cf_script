module CfScript::Command
  class Apps::RenameCommand < CfScript::Command::Base
    def initialize
      super(:apps, :rename)
    end

    def run(old_name, new_name, &block)
      run_cf self, old_name, new_name do |output|
        return false unless good_run?(output, check_failed: false)

        if output.ok?
          block_given? ? yield(true) : true
        else
          error "failed to rename app"
          return false
        end
      end
    end
  end
end
