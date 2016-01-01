require 'open3'

class CfScript::Executor::NonBlocking
  include CfScript::UI

  READ_SIZE = 1024

  PROGRESS_CHARS = ['|', '/', '-', '\\']

  def initialize
    @executions = 0
    @spin_count = 0
  end

  def execute(env, command_line)
    @spin_count = 0
    @executions += 1

    print " ...  "
    stdout, stderr, status = execute_internal(env, command_line)

    report_exit(status.exitstatus == 0 ? :success : :error)

    [stdout, stderr, status]
  end

  def spin
    char = PROGRESS_CHARS[(@spin_count += 1) % PROGRESS_CHARS.length]

    print "\b#{char}".colorize(with_color_of(:step))
  end

  def got(c = '@')
    print "\b#{c}".colorize(with_color_of(:info))
  end

  def report_exit(type)
    icon = "#{emoji_for(type)}          "
    text = case type
           when :success
             CfScript.config.ui.emoji ? icon : 'DONE '
           else
             CfScript.config.ui.emoji ? icon : 'ERROR'
           end

    puts "\b\b\b\b\b#{text}".colorize(with_color_of(type))
  end

  def execute_internal(env, command_line)
    out_stdout = ''
    out_stderr = ''
    out_status = nil

    Open3.popen3(env, command_line.to_s) do |stdin, stdout, stderr, wait|
      stdin.close_write

      begin
        streams = [stdout, stderr]

       #until streams.empty? do
        loop do
          ready = IO.select(streams, [], [], 0.1)
          spin

          if ready
            readable = ready[0]

            readable.each do |stream|
              fileno = stream.fileno

              begin
                data = stream.read_nonblock(READ_SIZE)

                if fileno == stdout.fileno
                  got ; out_stdout << data
                elsif fileno == stderr.fileno
                  got ; out_stderr << data
                else
                  fileno_error(fileno, stdin, stdout, stderr)
                end
              rescue EOFError => e
              # puts "EOF-ERROR".colorize(with_color_of(:error))
              # streams.delete(stream)
              end
            end
          end

          break if stdout.eof? && stderr.eof?
        end

        out_status = wait.value
      rescue IOError => e
        puts "IOError: #{e}"
      end
    end

    [out_stdout, out_stderr, out_status]
  end

  def fileno_error(fileno, stdin, stdout, stderr)
    puts "ERROR: unexpected fileno: #{fileno} [" +
        "stdin: #{stdin.fileno}, " +
        "stdout: #{stdout.fileno}, " +
        "stderr: #{stderr.fileno}" +
      "]"
  end
end
