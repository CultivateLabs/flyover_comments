module FlyoverComments
  module Commentable
    def flyover_commentable
      has_many :comments, -> { where('flyover_comments.comment_type = ?', nil) }, as: :commentable, class_name: "::FlyoverComments::Comment"
      has_many :pre_publication_comments, -> { where('flyover_comments.comment_type = ?', "pre_publication") }, as: :commentable, class_name: "::FlyoverComments::Comment"
    end
  end
end
