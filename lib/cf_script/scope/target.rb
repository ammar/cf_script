module CfScript::Scope
  class Target < Base
    def current_org
      @current_target ? @current_target.org : ''
    end

    def current_space
      @current_target ? @current_target.space : ''
    end

    def target(*args, &block)
      unless args.empty?
        # TODO: check if it's the same org too
        if args.first.to_s == current_space
          return @current_target
        end
      end

      @current_target = CfScript::Command.run(:target, *args)

      block_given? ? yield(@current_target) : @current_target
    end

    def space(space_name, &block)
      space_scope = nil

      if block_given?
        space_scope = CfScript::Scope::Space.new(space_name)

        exec_in(space_scope, nil, &block)
      else
        CfScript::Command.space(space_name)
      end
    ensure
      space_scope.finalize if space_scope
    end

    def app(name_or_info, &block)
      if block_given?
        app = CfScript::Scope::App.new(name_or_info, @current_target)

        exec_in(app, nil, &block)
      else
        app_name = name_or_info.respond_to?(:name) ? name_or_info.name : name_or_info

        CfScript::Command.app(app_name)
      end
    end

    def apps(options = {}, &block)
      apps = CfScript::Command.apps

      apps.select!(options) unless options.empty?

      block_given? ? yield(apps) : apps
    end

    private

    def target_desc(t)
      desc = ''
      desc << (t.org.nil? || t.org.empty? ? 'ORG-NOT-SET' : t.org)
      desc << ':'
      desc << (t.space.nil? || t.space.empty? ? 'SPACE-NOT-SET' : t.space)
    end

    def enter_scope
      if current = target
        @initial_target = @current_target = current
      end

      raise "Could not set initial and current targets" unless
        @initial_target and @current_target

      trace scope_name, "enter_scope: " +
        "initial: (#{target_desc(@initial_target)}), " +
        "current: (#{target_desc(@current_target)})"
    end

    def exit_scope
      trace scope_name, "exit_scope: " +
        "initial: (#{target_desc(@initial_target)}), " +
        "current: (#{target_desc(@current_target)})"

      if @initial_target.org != current_org or @initial_target.space != current_space
        target(@initial_target)
      end
    end
  end
end
