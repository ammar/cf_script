module CfScript::Command
  module Runner
    module_function

    def run_cf(command, *args, &block)
      run_command(command, *args, &block)
    rescue CfScript::Command::Error => exception
      error command.name, exception.message
    end

    def cf_id
      "#{cf_version} (path: #{cf_path})"
    end

    def cf_version
      `#{cf_bin} --version`.chomp.split(' ')[1..-1].join(': ')
    end

    def cf_bin
      @cf_bin  ||= cf_in_path? && !cf_in_env? ? 'cf' : cf_path
    end

    def which_cf
      `which cf`.chomp
    end

    def cf_in_path?
      !which_cf.empty?
    end

    def cf_in_env?
      !ENV['CF_BINARY'].nil?
    end

    def cf_path
      unless @cf_path
        @cf_path = ENV['CF_BINARY'] || which_cf

        if @cf_path.nil? || @cf_path.empty?
          puts "Could not find the cf binary".colorize(:red)
          puts
          puts "If it isn't installed you need to install it first. You can find"
          puts "the latest release at:"
          puts
          puts "  https://github.com/cloudfoundry/cli/releases".colorize(:cyan)
          puts
          puts "If cf is already installed, make sure its location is included "
          puts "in $PATH."

          raise "Could not find the cf binary"
        end
      end

      @cf_path
    end

    def cf_env
      # When things go wrong dump the output of cf to the terminal, and the
      # colors make it easier to read.
      ENV['CF_COLOR'] ||= CfScript.config.runtime.color ? 'true' : 'false'
      ENV['CF_TRACE'] ||= ENV['DEBUG'] ? 'true' : 'false'
      ENV
    end

    private

    def cf_executor
      CfScript.config.runtime.executor
    end

    def run_command(command, *args, &block)
      command_line = command.line(cf_env, cf_bin, args)

      trace(:running, command_line.hide_sensitive, true)

      stdout, stderr, status = cf_executor.execute(cf_env, command_line)

      output = CfScript::Output.new(command_line, stdout, stderr, status)

      unless output.good?
        run_error!(command_line, output)
      end

      block_given? ? yield(output) : output
    end

    def run_error!(command_line, output)
      unless CfScript.stdout.is_a?(StringIO)
        CfScript.stdout.puts output.stdout unless output.stdout.empty?
      end

      unless CfScript.stderr.is_a?(StringIO)
        CfScript.stderr.puts output.stderr unless output.stderr.empty?
      end
    end
  end
end
