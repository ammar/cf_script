MiniTest::Test.class_eval do
  def self.shared_examples
    @shared_examples ||= {}
  end
end

module MiniTest::Test::SharedExamples
  def shared_examples_for(desc, &block)
    MiniTest::Test.shared_examples[desc] = block
  end

  def it_behaves_like(desc, *args)
    raise "Unknown shared example '#{desc}' in it_behaves_like" unless
      MiniTest::Test.shared_examples[desc]

    if args.empty?
      self.instance_eval(&MiniTest::Test.shared_examples[desc])
    else
      self.instance_exec(*args, &MiniTest::Test.shared_examples[desc])
    end
  end

  alias :it_is :it_behaves_like
end

Object.class_eval { include(MiniTest::Test::SharedExamples) }

# Load all shared example files
shared_examples_dir = File.expand_path('../shared_examples', __FILE__)
Dir["#{shared_examples_dir}/**/*.rb"].each {|f| require f}
