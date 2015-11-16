module FlyoverComments
  module LinkParsing

    LINK_REGEX = /((?:http:\/\/|https:\/\/|www.)\S+)/
ASDF = /\b((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/?)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s\`!()\[\]{};:\'\".,<>?«»“”‘’]))/i

    def parse_links(field)
      content = send(field)
      return [] if content.blank?
      content.scan(ASDF).flatten.compact
    end

    def contains_links?(field)
      !parse_links(field).empty?
    end

    def add_html_tags_to_detected_links(value)
      value.gsub(ASDF) do |match|
        href = match.include?("://") ? match : "http://#{match}"
        "<a target=\"_blank\" href=\"#{href}\">#{match}</a>"
      end
    end

  end
end
