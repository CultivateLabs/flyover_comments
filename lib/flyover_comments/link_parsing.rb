module FlyoverComments
  module LinkParsing

    LINK_REGEX = /\b((?:https?:\/\/|www\d{0,3}[.])(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s\`!()\[\]{};:\'\".,<>?«»“”‘’]))/i
    #shoutout to Ryan Angilly (http://ryanangilly.com/post/8654404046/grubers-improved-regex-for-matching-urls-written)

    def parse_links(field)
      content = send(field)
      return [] if content.blank?
      content.scan(LINK_REGEX).flatten.compact
    end

    def contains_links?(field)
      !parse_links(field).empty?
    end

    def add_html_tags_to_detected_links(value)
      value.gsub(LINK_REGEX) do |match|
        href = match.include?("://") ? match : "http://#{match}"
        "<a target=\"_blank\" href=\"#{href}\">#{match}</a>"
      end
    end

  end
end
