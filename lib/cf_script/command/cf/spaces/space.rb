module CfScript::Command
  class Spaces::SpaceCommand < CfScript::Command::Base
    def initialize
      super(:spaces, :space)
    end

    def run(space_name, &block)
      run_cf self, space_name do |output|
        return unless can_run?(output)

        if space = build_space(space_name, output)
          block_given? ? yield(space) : space
        else
          error 'object is nil'
        end
      end
    end

    private

    def build_space(space_name, output)
      attrs = output.attributes

      unless attrs.empty?
        space = CfScript::Space.new(
          space_name,
          attrs[:org].value,
          attrs[:apps].to_a,
          attrs[:domains].to_a,
          attrs[:services].to_a,
          attrs[:security_groups].to_a
        )
      end
    end
  end
end
