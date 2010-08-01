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
    
    describe "page" do
      it "should return 1 if @page.nil?" do
        page.should == 1
      end
      
      [1, 21, 302, "4", "501", "602"].each do |p|
        it "should return value of page #{p} in it's integer format" do
          page p
          page.should == p.to_i
        end
      end
      
      context "within an actual app" do
        before(:all) do
          app.get "/get/page/value/if" do
            "The page is #{page}"
          end
        end
        
        it "should actually work inside the app" do
          get "/get/page/value/if/page/123"
          last_response.should be_ok
          last_response.body.should == "The page is 123"
          last_request.url.should == "http://example.org/get/page/value/if"
        end
      end
    end
    
    describe "href_for_pagin" do
      describe "" do
        before(:each) do
          stub!(:request)
          request.stub!(:path_info).and_return '/2009/10'
        end
      
        it "should return a paginated uri based on the current request" do
          page 2
        
          next_page = href_for_pagin(3, :next)
          prev_page = href_for_pagin(3, :prev)
        
          next_page.should == "/2009/10/page/3"
          prev_page.should == "/2009/10/page/1"
        end
      
        it "should return ../page/1 for :prev if page is 1" do
          page 1
          href_for_pagin(3, :prev).should == "/2009/10/page/1"
        end
      
        it "should return ../page/*total_pages for :next if page is the last page" do
          page 3
          href_for_pagin(3, :next).should == "/2009/10/page/3"
        end

        it "allows for the base path to be overridden" do
          page 2
          href_for_pagin(3, :next, '/base/path').should == '/base/path/page/3'
        end
      end
      
      context "within an actual app" do
        before(:all) do
          app.get "/this/path/should/be/base" do
            total_pages = 4
            <<-HTML
              <a href="#{href_for_pagin(total_pages, :prev)}">previous</a> |
              <a href="#{href_for_pagin(total_pages, :next)}">next</a>
            HTML
          end
        end
        
        it "should return the proper hrefs given ../page/1" do
          get "/this/path/should/be/base/page/1"
          last_response.should be_ok
          last_response.should have_selector 'a', :href => "/this/path/should/be/base/page/1" do |a|
            a.inner_text.should == 'previous'
          end
          last_response.should have_selector 'a', :href => "/this/path/should/be/base/page/2" do |a|
            a.inner_text.should == 'next'
          end
        end
        
        [2, 3].each do |p|
          it "should return the proper hrefs given ../page/#{p}" do
            get "/this/path/should/be/base/page/#{p}"
            last_response.should be_ok
            last_response.should have_selector 'a', :href => "/this/path/should/be/base/page/#{p-1}" do |a|
              a.inner_text.should == 'previous'
            end
            last_response.should have_selector 'a', :href => "/this/path/should/be/base/page/#{p+1}" do |a|
              a.inner_text.should == 'next'
            end
          end
        end
        
        it "should return the proper hrefs given ../page/4" do
          get "/this/path/should/be/base/page/4"
          last_response.should be_ok
          last_response.should have_selector 'a', :href => "/this/path/should/be/base/page/3" do |a|
            a.inner_text.should == 'previous'
          end
          last_response.should have_selector 'a', :href => "/this/path/should/be/base/page/4" do |a|
            a.inner_text.should == 'next'
          end
        end
      end
    end
  end
end
