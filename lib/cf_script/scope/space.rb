module CfScript::Scope
  class Space < Target
    def initialize(space_name = nil)
      super()

      target(space_name) if space_name
    end
  end
end
