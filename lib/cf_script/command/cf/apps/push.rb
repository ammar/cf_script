module CfScript::Command
  class Apps::PushCommand < CfScript::Command::Apps::Base
    LONG_OPTIONS_MAP = {
      manifest:           :f,
      instances:          :i,
      memory:             :m,
      command:            :c,
      buildpack:          :b,
      hostname:           :n,
      domain:             :d,
      disk:               :k,
      path:               :p,
      stack:              :s,
      timeout:            :t,
      docker_image:       :o,
      health_check_type:  :u,
    }

    def initialize
      super(:apps, :push)
    end

    def run(app_name, options = {}, &block)
      run_cf self, app_name, translate_options(options.dup) do |output|
        return unless can_run?(output, check_failed: false)

        if app = build_app_info(app_name, output)
          block_given? ? yield(app) : app
        else
          error "app is nil"
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
