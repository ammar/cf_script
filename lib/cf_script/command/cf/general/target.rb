module CfScript::Command
  class General::TargetCommand < CfScript::Command::Base
    NOT_LOGGED_IN = 'Not logged in'

    def initialize
      super(:general, :target)
    end

    def run(space_name_or_target = nil, &block)
      args  = build_args(space_name_or_target)
      space = args.first && args.first.key?(:s) ? args.first[:s] : ''

      run_cf self, *args do |output|
        return nil unless can_run?(output, check_failed: false)

        # TODO: check org not found too

        if output.not_found?('Space', space)
          error "Space #{space} not found"
          return
        end

        if target = build_target(output)
          block ? yield(target) : target
        else
          error 'object is nil'
        end
      end
    end

    private

    def build_args(name_or_target)
      case name_or_target
      when String, Symbol
        # TODO: add org if present
        [{ s: name_or_target }]
      when CfScript::Target
        [name_or_target.to_options]
      else
        []
      end
    end

    def build_target(output)
      attrs = output.attributes

      unless attrs.empty?
        target = CfScript::Target.new(
          attrs[:api_endpoint].value,
          attrs[:org].value,
          attrs[:space].value,
          attrs[:user].value
        )

        if target.space =~ /No space targeted/
          target.space = ''
        end

        target
      end
    end
  end
end
