require "flyover_comments/engine"

module FlyoverComments
  mattr_accessor :user_class
  @@user_class = 'User'

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
  end
end
