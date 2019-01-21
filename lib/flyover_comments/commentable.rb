module FlyoverComments
  module Commentable
    def flyover_commentable
      has_many :comments, -> { where('flyover_comments.comment_type = ?', nil) }, as: :commentable, class_name: "::FlyoverComments::Comment"
    end
  end
end
