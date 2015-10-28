class AddUpvotesCountAndDownvotesCountToFlyoverCommentsComment < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :upvote_count, :integer, default: 0
    add_column :flyover_comments_comments, :downvote_count, :integer, default: 0
    FlyoverComments::Comment.reset_column_information
    FlyoverComments::Comment.find_each do |comment|
      comment.reset_vote_counts!
    end
  end
end
