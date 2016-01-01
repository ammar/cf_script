module CfScript::Command::General
  class ApiCommand < CfScript::Command::Base
    API_NOT_SET = 'No api endpoint set'

    API_ENDPOINT_REGEX = %r|API endpoint:\s+(?<url>https?://[\S]+)\s+\(API version:\s+(?<version>[^)]+)\)|

    def initialize
      super(:general, :api)
    end

    def run(url = nil, &block)
      run_cf self, url do |output|
        return unless can_run?(output)

        if output.contains? API_NOT_SET
          error API_NOT_SET
        else
          build_endpoint(output)
        end
      end
    end

    private

    def build_endpoint(output)
      attrs = output.line_attributes API_ENDPOINT_REGEX

      unless attrs.nil? or attrs.empty?
        CfScript::ApiEndpoint.new(
          attrs[:url].value,
          attrs[:version].value
        )
      end
    end
  end
end
