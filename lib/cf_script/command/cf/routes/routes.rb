module CfScript::Command
  class Routes::RoutesCommand < CfScript::Command::Base
    ROUTES_TABLE = ['space', 'host', 'domain', 'apps']

    def initialize
      super(:routes, :routes)
    end

    def run(*args, &block)
      run_cf self do |output|
        return unless good_run?(output)

        if rows = output.table(ROUTES_TABLE)
          routes = build_route_info(rows)

          block_given? ? yield(routes) : routes
        else
          error "Routes table was not found"
        end
      end
    end

    private

    def build_route_info(rows)
      routes = []

      rows.each do |row|
        routes << CfScript::RouteInfo.new(
          row[:space].value,
          row[:host].value,
          row[:domain].value,
          row[:apps].to_a
        )
      end

      routes
    end
  end
end
