module FlyoverComments
  class Engine < ::Rails::Engine
    isolate_namespace FlyoverComments

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
