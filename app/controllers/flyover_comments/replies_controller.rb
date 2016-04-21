require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class RepliesController < ApplicationController
    include FlyoverComments::Authorization

    def index
      @comment = FlyoverComments::Comment.with_includes.find(params[:comment_id])
      authorize_flyover_comment_show!
    end

  end
end
