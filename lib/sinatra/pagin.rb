require 'sinatra/base'

module Sinatra
  module Pagin
    def self.registered(app)
      app.helpers Pagin::Helpers
      
      app.before do
        page_pattern = /\/page\/(\d+)(\/)?(\.[^\.\/]+)?$/
        request.path_info.match(page_pattern)
        
        if $1
          page $1
          request.path_info = request.path_info.gsub!(page_pattern, '')+$3.to_s
          request.path_info.gsub!(/^(?!\/)/) { |s| "/"+s } # force the first slash if not avail
        end
      end
    end
    
    module Helpers
      def page(pg = 1)
        unless pg == 1
          @page = pg.to_i
        end
        
        @page || 1
      end
      
      def href_for_pagin(total_pages, direction = :next)
        path_info = request.path_info.gsub(/\/$/, '') # clear off the last slash just in case
        page_num  = 1
        
        case
        when direction === :next
          page_num = page+1 >= total_pages ? total_pages : page+1
        when direction === :prev
          page_num = page-1 <= 0 ? 1 : page-1
        end
        
        path_info+"/page/#{page_num}"
      end
    end
  end
  
  Sinatra::Application.register Pagin
end