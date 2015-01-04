module FlyoverComments
  module Commentable
    def flyover_commentable
      has_many :comments, as: :commentable, class_name: "::FlyoverComments::Comment"
    end
  end
end