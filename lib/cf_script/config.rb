class CfScript::Config
  attr_reader :io
  attr_reader :ui
  attr_reader :runtime

  def initialize
    @io = CfScript::Config::IO.new
    @ui = CfScript::Config::UI.new

    @runtime = CfScript::Config::Runtime.new
  end

  class IO
    attr_accessor :stdout
    attr_accessor :stderr

    def initialize
      @stdout = $stdout
      @stderr = $stderr
    end
  end

  class UI
    attr_accessor :tags
    attr_accessor :emoji
    attr_reader   :color # Special case for String.disable_colorization

    def initialize
      @tags  = true
      @emoji = false
      @color = true
    end

    def color=(state)
      @color = state

      if String.respond_to?(:disable_colorization)
        String.disable_colorization = @color ? false : true
      end
    end
  end

  class Runtime
    attr_accessor :trace
    attr_accessor :color

    attr_accessor :executor
    attr_accessor :echo_output

    def initialize
      @trace = ENV['TRACE'] || false
      @color = true

      @executor = default_executor
      @echo_output  = true
    end

    def default_executor
      CfScript::Executor::Simple.new
    end
  end
end
