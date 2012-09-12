# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "format"
  gem.homepage = "http://github.com/Arcterus/format"
  gem.license = "MIT"
  gem.summary = %Q{A formatter for the UNIX, Java, and Allman indentation/bracketing styles.}
  gem.description = %Q{A formatter for the UNIX, Java, and Allman indentation/bracketing styles.}
  gem.email = "arcterus@mail.com"
  gem.authors = ["Arcterus"]
  gem.executables = 'format'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << '.' << '../test'
  test.pattern = '../test/**/test_*.rb'
  test.verbose = true
end

=begin
require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end
=end

task :default => :test

=begin
require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "format #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
=end

require 'yard'
require 'yard/rake/yardoc_task'

YARD::Rake::YardocTask.new do |yard|
    version = File.exist?('VERSION') ? File.read('VERSION') : ''

    yard.files = ['lib/**/*.rb', 'README*']
    yard.options = ['--no-private', '--protected', '--title', "\"format #{version}\"", '-o', 'doc']
end
