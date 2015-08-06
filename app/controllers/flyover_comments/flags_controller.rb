require_dependency "flyover_comments/application_controller"
require_dependency "flyover_comments/authorization"

module FlyoverComments
  class FlagsController < ApplicationController
    include FlyoverComments::Authorization

    def create
    end
  end
end
