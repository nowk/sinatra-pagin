require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MyTestApp < Sinatra::Base
  set :environment, :test
  
  get "/"do
    "Hello World!"
  end
  
  get "/a/pathed" do
    "Foo Bar!"
  end
end

describe 'Sinatra' do
  
  def app
    @app ||= MyTestApp
  end
  
  def get_absolute(uri)
    page_pattern = /\/page\/(\d+)(\/)?(\.[^\.\/]+)?$/
    uri.match(page_pattern)
    
    if $1
      uri = uri.gsub(page_pattern, '')+$3.to_s
      uri.gsub!(/^(?!\/)/) { |s| "/"+s }
    end
    
    return uri
  end
  
  describe "MyTestApp" do
    it "should actually work" do
      get "/" do |response|
        response.should be_ok
        response.should contain "Hello World!"
      end
      
      get "/a/pathed" do |response|
        response.should be_ok
        response.should contain "Foo Bar!"
      end
    end
  end
  
  describe "without Pagin" do
    ["/", "/a/pathed"].each do |uri|
      it "should respond ok to #{uri}" do
        get uri
        last_response.should be_ok
        last_request.url.should == "http://example.org#{uri}"
      end
    end
    
    ["/page/45", "/a/pathed/page/2"].each do |uri|
      it "should not respond ok to #{uri}" do
        get uri
        last_response.should_not be_ok
        last_response.status.should == 404
        last_request.url.should == "http://example.org#{uri}"
      end
    end
  end
  
  describe "with Pagin" do
    before(:all) do
      MyTestApp.register Sinatra::Pagin
    end
    
    ["/", "/a/pathed"].each do |uri|
      it "should respond ok to #{uri}" do
        get uri
        last_response.should be_ok
        last_request.url.should == "http://example.org#{uri}"
      end
    end
    
    ["/page/123", "/a/pathed/page/32"].each do |uri|
      it "should respond ok to #{uri}" do
        get uri
        last_response.should be_ok
        last_request.url.should == "http://example.org#{get_absolute(uri)}"
      end
    end
    
    [
      "/page",
      "/page/",
      "/page/a",
      "/a/pathed/page", 
      "/a/pathed/page/",
      "/a/pathed/page/1two", 
      "/a/pathed/page/one2three"
    ].each do |uri|
      it "should not respond ok to #{uri}" do
        get uri
        last_response.should_not be_ok
        last_response.status.should == 404
        last_request.url.should == "http://example.org#{uri}"
      end
    end
    
    it "should not respond ok to multiple interations of /page/# ex: /page/1/page/2" do
      get "/page/1/page/2"
      last_response.should_not be_ok
      last_response.status.should == 404
      last_request.url.should == "http://example.org/page/1"
    end
    
    it "should accept a page/0" do
      get "/page/0"
      last_response.should be_ok
      last_request.url.should == "http://example.org/"
    end
    
    describe ".:format" do
      before(:all) do
        app.get "/a/pathed/with.:format" do
          "Howdy!"
        end
      end
      
      it "should respond ok to a path with a .:format" do
        get "/a/pathed/with.html"
        last_response.should be_ok
        last_response.body.should contain "Howdy!"
        last_request.url.should == "http://example.org/a/pathed/with.html"
      end
      
      it "should reattach the .:format back to the url" do
        get "/a/pathed/with/page/3.html"
        last_response.should be_ok
        last_response.body.should contain "Howdy!"
        last_request.url.should == "http://example.org/a/pathed/with.html"
      end
    end
  end
  
  describe "Helpers" do
    include Sinatra::Pagin::Helpers
    
    describe "current_page" do
      it "should return 1 if @page.nil?" do
        page.should == 1
      end
      
      [1, 21, 302, "4", "501", "602"].each do |p|
        it "should return value of page #{p} in it's integer format" do
          page p
          page.should == p.to_i
        end
      end
      
      it "should actually work inside the app" do
        app.get "/get/page/value/if" do
          "The page is #{page}"
        end
        
        get "/get/page/value/if/page/123"
        last_response.should be_ok
        last_response.body.should == "The page is 123"
        last_request.url.should == "http://example.org/get/page/value/if"
      end
    end
  end
end