require 'pty'
require 'io/console'

class CfScript::Executor::Simple
  def execute(env, command_line)
		out = ''

		PTY.spawn(command_line.to_s)do |i, o, pid|
			begin
				i.sync
        i.raw!

				i.each_line do |line|
          echo(line)
					out << line
				end
			rescue Errno::EIO
				# Ignored
			ensure
				::Process.wait pid
			end
		end

    [out, '', $?]
  end

  def echo(line)
    STDOUT.print line if CfScript.config.runtime.echo_output
  end
end
