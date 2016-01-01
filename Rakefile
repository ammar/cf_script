require 'rubygems'

require 'rake'
require 'rake/testtask'

require 'bundler'
require 'rubygems/package_task'

Bundler::GemHelper.install_tasks

task :default => [:test]

Rake::TestTask.new('test') do |t|
  if t.respond_to?(:description)
    t.description = "Run all unit tests under the test directory"
  end

  t.libs << "test"
  t.test_files = FileList['test/**/*.rb']
end

namespace :test do
  %w{commands runner parser}.each do |component|
    Rake::TestTask.new(component) do |t|
      if t.respond_to?(:description)
        t.description = "Run all #{component} unit tests under the test/#{component} directory"
      end

      t.libs << "test"
      t.test_files = ["test/#{component}/**/*.rb"]
    end
  end
end
