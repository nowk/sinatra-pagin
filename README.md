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

    get "/" do
      "hello world, you asked for page #{page}"
    end
    
    # => hello world, you asked for page 2
    
*`page`* returns 1 as a default.

It also supports `.:format` in your path.

    get "/a/pathed/path.:format" do
      "foo bar"
    end
    
    http://example.org/a/pathed/path/page/45.js
    # => path_info == /a/pathed/path.js
    # => page == 45

### TODO

- Maybe gemspec
- Fix whatever breaks along the way.
- Whatever else...

### Resources

- [Checked with Integrity][1]


### License

The MIT License

Copyright (c) 2010 Yung Hwa Kwon

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE

[0]: http://www.sinatrarb.com/
[1]: http://ci.damncarousel.com/sintra-pagin