class AddCommenterFieldsToFlagsAndVotes < ActiveRecord::Migration
  def change
    add_column :flyover_comments_flags, :flagger_id, :integer
    add_column :flyover_comments_flags, :flagger_type, :string
    add_column :flyover_comments_votes, :voter_id, :integer
    add_column :flyover_comments_votes, :voter_type, :string

    user_class_underscore = FlyoverComments.user_class_underscore
    FlyoverComments::Flag.update_all(flagger_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)
    FlyoverComments::Flag.find_each do |flag|
      flag.update_attribute(:flagger_id, flag.send("#{user_class_underscore}_id"))
    end

    FlyoverComments::Vote.update_all(voter_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)
    FlyoverComments::Vote.find_each do |vote|
      vote.update_attribute(:voter_id, vote.send("#{user_class_underscore}_id"))
    end
  end
end
