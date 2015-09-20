module Kaminari
  module Helpers
    class Tag

      def page_url_for(page)
        route_set = @params.delete(:route_set) || @template.main_app
        arguments = @params.merge(@param_name => (page <= 1 ? nil : page), :only_path => true).symbolize_keys
        route_set.url_for arguments
      end

    end
  end
end
