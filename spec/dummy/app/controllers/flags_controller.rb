class FlagsController < ApplicationController
  def show
    @comments = FlyoverComments::Comment.all
  end
end
