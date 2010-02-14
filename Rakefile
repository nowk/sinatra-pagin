require 'rubygems'
require 'hoe'

Hoe.plugins.delete :rubyforge
Hoe.plugin :gemcutter
Hoe.plugin :clean
Hoe.plugin :git

Hoe.spec 'sinatra-pagin' do
  developer('Yung H Kwon', 'yung.kwon@example.com')
  
  extra_deps << ['sinatra', '>= 0.9.4']
  extra_dev_deps = [
    ['rack-test', '>= 0.5.2'],
    ['rspec', '>= 1.2.8'],
    ['webrat', '>= 0.7.0']
  ]

  # self.rubyforge_name = 'nowk-sinatra-pagin' # if different than 'sinatra-pagin'
  self.readme_file = 'README.rdoc'
  self.history_file = 'History.txt'
  self.test_globs = 'spec/*_spec.rb'
  self.version = '0.0.1'
end

# 

begin
  require 'spec'
  require 'spec/rake/spectask'
  
  task :default => :spec
  
  namespace :spec do
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
  puts "I <3 Rspec, or any good testing unit for that matter."
  puts "RSpec required. To install Rspec, please run sudo gem install rspec."
end

