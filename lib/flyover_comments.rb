require "flyover_comments/engine"

module FlyoverComments
  mattr_accessor :user_class, :current_user_method, :application_controller_superclass, 
                 :enable_comment_counter_cache, :insert_html_tags_for_detected_links,
                 :auto_escapes_html_in_comment_content
  @@user_class = 'User'
  @@current_user_method = "current_user"
  @@application_controller_superclass = "::ApplicationController"
  @@enable_comment_counter_cache = false
  @@insert_html_tags_for_detected_links = true
  @@auto_escapes_html_in_comment_content = true

  class << self
    def configure
      yield self
    end

    def user_class
      @@user_class.constantize
    end

    def user_class_underscore
      @@user_class.gsub("::", "").underscore
    end

    def user_class_symbol
      user_class_underscore.to_sym
    end

    def application_controller_superclass
      @@application_controller_superclass.constantize
    end
  end
end
