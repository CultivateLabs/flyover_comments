class AddUpvotesCountAndDownvotesCountToFlyoverCommentsComment < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_comments, :upvote_count, :integer, default: 0
    add_column :flyover_comments_comments, :downvote_count, :integer, default: 0
    FlyoverComments::Comment.reset_column_information
    FlyoverComments::Comment.find_each do |comment|
      comment.recalculate_vote_counts!
    end
  end
end
