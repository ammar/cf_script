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

    def push(options = {})
      CfScript::Command.push name, options do |app_info|
        @app_info = app_info if app_info
      end
    end
  end
end
