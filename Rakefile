require 'rubygems'

begin
  require 'spec'
  require 'spec/rake/spectask'
  
  task :default => :spec
  
  task :spec do
    Spec::Rake::SpecTask.new do |t|
      #t.ruby_opts = ['-rtest/unit']
      t.spec_files = FileList['spec/*_spec.rb']
    end
  end
  
  task :ci => 'setup:gem_bundle'  do
    Rake::Task[:spec].invoke
  end
  
  namespace :setup do
    task :gem_bundle do
      sh "gem bundle --only test"
      require "vendor/gems/environment"
    end
  end
  
rescue LoadError
  puts "RSpec required. To install Rspec, please run sudo gem install rspec."
  puts "I <3 Rspec, or any good testing unit for that matter."
end

