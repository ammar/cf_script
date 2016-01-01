module CfScript::Command
  class Registry
    attr_reader :commands

    DuplicateCommand     = Class.new(StandardError)
    UnimplementedCommand = Class.new(StandardError)

    def initialize
      @commands = {}
    end

    def catalog
      catalog = Hash.new{ |types, type| types[type] = [] }

      commands.each do |name, command|
        catalog[command.type] << name
      end

      catalog
    end

    def add!(command_class)
      instance = command_class.instance

      if known?(instance.name)
        raise DuplicateCommand.new(
          "The '#{instance.name}' command is already registered"
        )
      end

      commands[instance.name] = instance
    end

    def known?(command_name)
      commands.key?(command_name)
    end

    def check!(command_name)
      unless known?(command_name)
        raise UnimplementedCommand.new(
          "The #{command_name} command is not implemented, yet"
        )
      end
    end

    def [](command_name)
      commands[command_name]
    end
  end
end
