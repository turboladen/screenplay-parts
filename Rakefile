# -*- ruby -*-

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files = %w(lib/**/*.rb - History.md)
  t.options = %W(--title screenplay-parts Documentation (#{Screenplay::Parts::VERSION}))
  t.options += %w(--main README.md)
end

RSpec::Core::RakeTask.new do |t|
  t.ruby_opts = %w(-w)
end

# Alias for rubygems-test
task :test => :spec

task :default => :build

# vim: syntax=ruby
