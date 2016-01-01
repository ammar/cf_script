module CfScript::Scope
  class Script < Target
    attr_reader :options

    VALID_OPTIONS = [:api, :org, :username, :password, :space]

    include CfScript::UI

    def initialize(options = {})
      super()

      @options = options
    end

    def run(&block)
      apply_options unless options.empty?

      exec_in(self, nil, &block)
    end

    def check_options
      options.keys.each do |key|
        unless VALID_OPTIONS.include?(key)
          alert :options, "#{key} is not a valid option for the " +
                          'cf method. It will be ignored.'
        end
      end
    end

    def apply_options
      check_options

      # If api is given and there are no username or password, set the api
      if options[:api] and (options[:username].nil? or options[:password].nil?)
        unless endpoint = CfScript::Command.api(options[:api])
          error :cf, "Could not set the API endpoint: #{options[:api]}"
          raise "Could not set the API endpoint: #{options[:api]}"
        end
      end

      # If username and password are given, call login. This also sets the api
      # and the space if they are given.
      if options[:username] and options[:password]
        unless CfScript::Command.login(options[:username], options[:password], options)
          error :cf, 'Could not login with given credentials'
          raise 'Could not login with given credentials'
        end
      end

      # If a space is given, don't set it if there is a username and password,
      # login would have already set it.
      if options[:space] and (options[:username].nil? or options[:password].nil?)
        # Use target, not CfScript::Command.target, so we can keep track of
        # the previous and current spaces and reset them on scope exit.
        target options[:space]
      end
    end
  end
end
