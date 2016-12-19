require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class FlagsController < ApplicationController
    include FlyoverComments::Authorization
    include FlyoverComments::Concerns::FlagsControllerAdditions

    respond_to :js, only: [:create]

    def create
      @comment = FlyoverComments::Comment.find(params[:comment_id])
      @flag = @comment.flags.new(flag_params)
      @flag.flagger = _flyover_comments_current_user
      authorize_flyover_flag_creation!
      @flag.save
      respond_with @flag
    end

    private

    def authorize_flyover_flag_creation!
      _foc_authorize @flag
      raise "User isn't allowed to flag comment" unless can_flag_flyover_comment?(@comment, _flyover_comments_current_user)
    end

    def flag_params
      params.require(:flag).permit(:reason)
    end

  end
end
