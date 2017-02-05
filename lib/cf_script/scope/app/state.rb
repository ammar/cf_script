module CfScript::Scope
  module App::State
    def start
      CfScript::Command.start name do |app_info|
        @app_info = app_info if app_info
      end
    end

    def stop
      CfScript::Command.stop name do |stopped|
        cf_self
      end
    end

    def restart
      CfScript::Command.restart name do |app_info|
        @app_info = app_info if app_info
      end
    end

    def push(options = {})
      CfScript::Command.push name, options do |app_info|
        @app_info = app_info if app_info
      end
    end

    def restage
      CfScript::Command.restage name do |app_info|
        @app_info = app_info if app_info
      end
    end

    def scale(options)
      CfScript::Command.scale name, options do |scaled|
        cf_self
      end
    end

    def restart_instance(index)
      CfScript::Command.restart_app_instance name, index do |restarted|
        cf_self
      end
    end
  end
end
