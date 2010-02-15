require 'rubygems'

# GEM
begin
  require 'jeweler'
  
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra-pagin"
    gem.summary = %Q{Small utility to process paginated urls without modifying the mapped paths in your Sinatra app}
    gem.description = %Q{Small utility to process paginated urls without modifying the mapped paths in your Sinatra app}
    gem.email = "yung.kwon@nowk.net"
    gem.homepage = "http://github.com/nowk/sinatra-pagin"
    gem.authors = ["Yung Hwa Kwon"]
    gem.add_dependency "sinatra", ">= 0.9.4"
    
    { 'rack-test' => '>= 0.5.2',
      'rspec' => '>= 1.2.8',
      'webrat' => '>= 0.7.0'
    }.each_pair do |g, v|
      gem.add_development_dependency g, v
    end
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

# Test Rakes
begin
  require 'spec'
  require 'spec/rake/spectask'
  
  task :default => :spec
  
  desc "Run Rspec tests"
  Spec::Rake::SpecTask.new(:spec) do |t|
    #t.spec_opts = ['spec/spec.opts']
    t.spec_files = FileList['spec/*_spec.rb']
  end
  
  desc "Run CI tests"
  task :ci => 'setup:gem_bundle'  do
    Rake::Task[:spec].invoke
  end
  
  namespace :setup do
    desc "Setup required gems/goodies for CI test. Server has only the essential minimums."
    task :gem_bundle do
      sh "gem bundle --only test"
      require "vendor/gems/environment"
    end
  end
  
rescue LoadError
  puts "I <3 Rspec, or any good testing unit for that matter."
  puts "RSpec required. To install Rspec, please run sudo gem install rspec."
end
