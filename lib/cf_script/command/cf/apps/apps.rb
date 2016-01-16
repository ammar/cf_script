module CfScript::Command
  class Apps::AppsCommand < CfScript::Command::Base
    NO_APPS_FOUND = 'No apps found'

    APPS_TABLE = [
      'name',
      'requested state',
      'instances',
      'memory',
      'disk',
      'urls'
    ]

    def initialize
      super(:apps, :apps)
    end

    def run(options = {}, &block)
      run_cf self do |output|
        blank_list = CfScript::AppList.new

        return blank_list unless good_run?(output)
        return blank_list if output.contains? NO_APPS_FOUND

        if rows = output.table(APPS_TABLE)
          list = build_app_list(rows)

          block_given? ? yield(list) : list
        else
          error 'rows is nil'
          return blank_list
        end
      end
    end

    private

    def build_app_list(rows)
      apps = rows.map do |row|
        CfScript::AppInfo.new(row[:name].value, row)
      end

      CfScript::AppList.new(apps)
    end
  end
end
