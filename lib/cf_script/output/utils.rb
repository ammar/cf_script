module CfScript
  module Output::Utils
    def dump
      list = []

      list << 'STATUS:' << status.inspect
      list << 'STDOUT:' << (stdout.size == 0 ? '<empty>' : stdout)
      list << 'STDERR:' << (stderr.size == 0 ? '<empty>' : stderr)

      CfScript.stderr.puts list.join("\n")
    end
  end
end
