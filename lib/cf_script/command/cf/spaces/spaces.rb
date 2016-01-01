module CfScript::Command
  class Spaces::SpacesCommand < CfScript::Command::Base
    SPACES_TABLE = ['name']

    def initialize
      super(:spaces, :spaces)
    end

    def run(*args, &block)
      run_cf self, *args do |output|
        return unless can_run?(output)

        if rows = output.table(SPACES_TABLE)
          spaces = rows.map { |row| row[:name].value }

          block_given? ? yield(spaces) : spaces
        else
          error "Spaces table was not found"
        end
      end
    end
  end
end
