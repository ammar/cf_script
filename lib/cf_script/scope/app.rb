require 'forwardable'

module CfScript::Scope
  class App < Base
    extend Forwardable

    attr_reader :name
    attr_reader :app_info
    attr_reader :current_target

    include CfScript::UI
    include CfScript::UI::NameTag

    def initialize(name_or_info, current_target)
      @current_target = current_target

      case name_or_info
      when String, Symbol
        @name     = name_or_info
        @app_info = nil
      when CfScript::AppInfo
        @name     = name_or_info.name
        @app_info = name_or_info
      else
        raise "App accepts a name (String or Symbol) or an AppInfo object, " +
              "but a #{name_or_info.class.name} was given"
      end

      cf_self
    end

    def_delegators :@app_info, :requested_state, :instances, :urls,
      :usage, :last_uploaded, :stack, :buildpack, :memory, :disk,
      :state, :started?, :hot?, :stopped?, :cold?

    def current_space
      current_target.space
    end

    def tag_color(type = nil)
      started? ? :active : :inactive
    end

    def name_tag
      "#{current_target.space}:#{name}"
    end

    private

    def cf_self
      CfScript::Command.app name do |app_info|
        @app_info = app_info if app_info
      end
    end
  end
end

require 'cf_script/scope/app/state'
require 'cf_script/scope/app/env'
require 'cf_script/scope/app/routes'
require 'cf_script/scope/app/utils'

class CfScript::Scope::App
  include State
  include Env
  include Routes
  include Utils
end
