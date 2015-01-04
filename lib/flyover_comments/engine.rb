require "flyover_comments/commentable"

module FlyoverComments
  class Engine < ::Rails::Engine
    isolate_namespace FlyoverComments

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "flyover_comments.active_record" do
      ActiveSupport.on_load(:active_record) do
        extend FlyoverComments::Commentable
      end
    end

    initializer 'flyover_comments.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper FlyoverComments::CommentsHelper
      end
    end

  end
end
