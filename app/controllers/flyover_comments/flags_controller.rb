require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class FlagsController < ApplicationController
    include FlyoverComments::Authorization

    respond_to :js, only: [:create]

    def create
      @comment = FlyoverComments::Comment.find(params[:comment_id])
      authorize_flyover_flag_creation!
      @flag = @comment.flags.new
      @flag._user = send(FlyoverComments.current_user_method.to_sym)
      @flag.save
      respond_with @flag
    end

    private

    def authorize_flyover_flag_creation!
      raise "User isn't allowed to flag comment" unless can_flag_flyover_comment?(@comment, send(FlyoverComments.current_user_method.to_sym))
    end

  end
end
