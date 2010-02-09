Sinatra::Pagin*
=
**Small utility to process paginated urls without modifying the mapped paths in your Sinatra app**

### Usage, *if you actually want to use this...*

To install, just grab the git, then require in your [Sinatra][0] app

    require 'lib/sinatra/pagin' # or wherever you install this ultimately

That is about it. 

Given you have mapped paths as such:

    get "/" do
      "hello world"
    end
    
    # => "http://example.org/"
    
    get "/a/pathed/path" do
      "foo bar"
    end
    
    # => "http://example.org/a/pathed/path"
    
Without changing those paths, you can run a paginated url.

    http://example.org/page/2
    # => get "/"
    
    http://example.org/a/pathed/path/page/45
    # => get "/a/pathed/path"

Use the helper method *`page`* to get the provide page number.

    http://example.org/page/2
    # => page == 2
    
    http://example.org/a/pathed/path/page/45
    # => page == 45
    
*`page`* returns 1 as a default.

It also supports `.:format` in your path.

    get "/a/pathed/path.:format" do
      "foo bar"
    end
    
    http://example.org/a/pathed/path/page/45.js
    
Will rewrite the uri to become
    
    /a/pathed/path.js
    
    # => page == 45

### TODO

- Maybe gemspec
- Fix whatever breaks along the way.
- Whatever else...

[0]: http://www.sinatrarb.com/