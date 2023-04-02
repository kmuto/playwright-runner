# frozen_string_literal: true

require 'bundler/gem_tasks'
task default: %i[test rubocop]

desc 'Run tests'
task :test, :target do |_, argv|
  if argv[:target].nil?
    ruby('test/run_test.rb')
  else
    ruby('test/run_test.rb', "--pattern=#{argv[:target]}")
  end
end

desc 'Check with rubocop'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  warn 'rubocop not found'
end
