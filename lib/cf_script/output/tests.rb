module CfScript
  module Output::Tests
    def matches?(regexp)
      out.matches?(regexp)
    end

    def contains?(text)
      out.contains?(text)
    end

    def ok?
      out.last_line_matches?(/^OK$/)
    end

    def authenticated?
      matches?(/Authenticating\.\.\.\nOK/m)
    end

    def failed?
      contains? 'FAILED'
    end

    def no_api_endpoint?
      contains? 'No API endpoint set'
    end

    def not_logged_in?
      contains? 'Not logged in'
    end

    def not_authorized?
      contains? 'You are not authorized'
    end

    def credentials_rejected?
      contains? 'Credentials were rejected'
    end

    def not_found?(type, name)
      out.last_line_matches?(/#{type} #{name} not found/)
    end

    def is_already?(name, state)
      out.last_line_matches?(/#{name} is already #{state}/)
    end

    def already_exists?(type, name)
      out.last_line_matches?(/#{type} #{name} already exists/)
    end
  end
end
