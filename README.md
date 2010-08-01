Sinatra::Pagin*
=

Small utility to process paginated urls without modifying the mapped paths in your Sinatra app

## Overview/Usage:


#### Basics:

Given you have mapped paths as such:

    get "/" do
      "hello world"
    end
    #=> "http://example.org/"
    
    get "/a/pathed/path" do
      "foo bar"
    end
    #=> "http://example.org/a/pathed/path"

Without changing those paths, you can run a paginated url. 

    require 'sinatra/pagin
    Sinatra::Application.register Sinatra::Pagin

###  

    http://example.org/page/2
    # => get "/"
    
    http://example.org/a/pathed/path/page/45
    # => get "/a/pathed/path"

*This is based on "pretty" style urls, page parameters sent in via the query string (.../?page=2) will be processed by Sinatra's usual params.

#### Helpers:

`page` returns the parsed "page" number.

    http://example.org/page/2
    
    get "/" do
      "hello world, you asked for page #{page}"
    end
    # => hello world, you asked for page 2

`page` returns 1 as a default.

##  

`href_for_pagin(total_pages, direction => :next)` href builder to build pagin valid hrefs for next & previous links based on the currently requested uri.

- total_pages => Integer (Required)
- direction => Symbol [:next | :prev] \(Defaults to => :next)

---
    http://example.org/2009/10/page/2
    
    href_for_pagin 4, :next
    #=> /2009/10/page/3
    
    href_for_pagin 4, :prev
    #=> /2009/10/page/1

## Additional notes:

It also supports `.:format` in your path.

    get "/a/pathed/path.:format" do
      "foo bar"
    end
    
    http://example.org/a/pathed/path/page/45.js
    # => path_info == /a/pathed/path.js
    # => page == 45

## Requirements:

* [Sinatra](http://www.sinatrarb.com/)

## Install:

Install the gem:

    sudo gem install sinatra-pagin

Require & Register in your app:

    require 'sinatra/pagin'

    Sinatra::Application.register Sinatra::Pagin

## Integrity

[Checked by Integrity](http://ci.damncarousel.com)

## License:

(The MIT License)

Copyright (c) 2010 Yung Hwa Kwon (yung.kwon@nowk.net)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
