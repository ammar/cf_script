$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'cf_script/version'

Gem::Specification.new do |gem|
  gem.name          = 'cf_script'
  gem.version       = ::CfScript::VERSION

  gem.summary       = 'A DSL for scripting the Cloud Foundry CLI'
  gem.description   = ''
  gem.homepage      = 'http://github.com/ammar/cf_script'

  if gem.respond_to?(:metadata)
    gem.metadata    = { 'issue_tracker' => 'https://github.com/ammar/cf_script/issues' }
  end

  gem.authors       = ['Ammar Ali']
  gem.email         = ['ammar@syntax.ps']

  gem.license       = 'MIT'

  gem.require_paths = ['lib']

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = Dir.glob('test/**/*.rb')

  gem.rdoc_options  = ["--inline-source", "--charset=UTF-8"]

  gem.platform      = Gem::Platform::RUBY

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency('colorize', '>= 0.7.7')
end
