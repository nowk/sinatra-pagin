require 'sinatra/base'

module Sinatra
  module Pagin
    def self.registered(app)
      app.helpers Pagin::Helpers
      
      app.before do
        page_pattern = /\/page\/(\d+)(\/)?(\.[^\.\/]+)?$/
        request.path_info.match(page_pattern)
        
        if @page = $1
          request.path_info = request.path_info.gsub!(page_pattern, '')+$3.to_s
          request.path_info.gsub!(/^(?!\/)/) { |s| "/"+s } # force the first slash if not avail
        end
      end
    end
    
    module Helpers
      def page
        @page || 1
      end
    end
  end
  
  Sinatra::Application.register Pagin
end