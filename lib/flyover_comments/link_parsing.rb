module FlyoverComments
  module LinkParsing
    
    LINK_REGEX = /((?:http:\/\/|https:\/\/|www.)\S+)/
    
    def parse_links(field)
      content = send(field)
      return [] if content.blank?
      content.scan(LINK_REGEX).flatten
    end
    
    def contains_links?(field)
      !parse_links(field).empty?
    end
    
    def add_html_tags_to_detected_links(value)
      value.gsub(LINK_REGEX) do |match| 
        href = match.include?("://") ? match : "http://#{match}"
        "<a href=\"#{href}\">#{match}</a>"
      end
    end
    
  end
end