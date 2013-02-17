require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/oryx'
  t.test_files = FileList['test/lib/oryx/*_test.rb']
  t.verbose = true
end
task :default => :test
