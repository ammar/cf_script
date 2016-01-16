CfScript::Command.const_set(:Apps, Module.new)

module CfScript::Command
  class Apps::Base < CfScript::Command::Base
    INSTANCE_STATUS_TABLE = [
      '',
      'state',
      'since',
      'cpu',
      'memory',
      'disk',
      'details'
    ]

    def build_app_info(app_name, output)
      attributes = output.attributes_from(
        'Showing health and status for app'
      )

      unless attributes.empty?
        app = CfScript::AppInfo.new(app_name, attributes)

        if rows = output.table(INSTANCE_STATUS_TABLE)
          app.set_instance_status rows
        end

        app
      end
    end
  end
end

require 'cf_script/command/cf/apps/apps'
require 'cf_script/command/cf/apps/app'
require 'cf_script/command/cf/apps/start'
require 'cf_script/command/cf/apps/stop'
require 'cf_script/command/cf/apps/restart'
require 'cf_script/command/cf/apps/push'
require 'cf_script/command/cf/apps/restage'
require 'cf_script/command/cf/apps/env'
require 'cf_script/command/cf/apps/set_env'
require 'cf_script/command/cf/apps/unset_env'
require 'cf_script/command/cf/apps/rename'
require 'cf_script/command/cf/apps/delete'

module CfScript::Command::Apps
  CfScript::Command.register AppsCommand
  CfScript::Command.register AppCommand
  CfScript::Command.register StartCommand
  CfScript::Command.register StopCommand
  CfScript::Command.register RestartCommand
  CfScript::Command.register PushCommand
  CfScript::Command.register RestageCommand
  CfScript::Command.register EnvCommand
  CfScript::Command.register SetEnvCommand
  CfScript::Command.register UnsetEnvCommand
  CfScript::Command.register RenameCommand
  CfScript::Command.register DeleteCommand
end
