module CfScript::Command
  class Apps::ScaleCommand < CfScript::Command::Apps::Base
    LONG_OPTIONS_MAP = {
      force_restart:      :f,
      instances:          :i,
      disk:               :k,
      memory:             :m,
    }

    def initialize
      super(:apps, :scale)
    end

    def run(app_name, options = {}, &block)
      run_cf self, app_name, translate_options(options) do |output|
        return unless good_run?(output, check_failed: false)

        if output.ok?
          block_given? ? yield(true) : true
        else
          error "failed to scale app"
          return false
        end
      end
    end

    def translate_options(options)
      opts = options.dup

      LONG_OPTIONS_MAP.each do |long, short|
        if opts.key?(long)
          opts[short] = opts.delete(long)
        end
      end

      opts
    end
  end
end
