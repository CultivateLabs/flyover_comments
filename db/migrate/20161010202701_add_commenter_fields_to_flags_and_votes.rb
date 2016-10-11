class AddCommenterFieldsToFlagsAndVotes < ActiveRecord::Migration
  def change
    add_column :flyover_comments_flags, :commenter_id, :integer
    add_column :flyover_comments_flags, :commenter_type, :string
    add_column :flyover_comments_votes, :commenter_id, :integer
    add_column :flyover_comments_votes, :commenter_type, :string

    user_class_underscore = FlyoverComments.user_class_underscore
    FlyoverComments::Flag.update_all(commenter_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)
    FlyoverComments::Flag.all.each do |flag|
      flag.update(commenter_id: flag.send("#{user_class_underscore}_id"))
    end

    FlyoverComments::Vote.update_all(commenter_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)
    FlyoverComments::Vote.all.each do |vote|
      vote.update(commenter_id: vote.send("#{user_class_underscore}_id"))
    end
  end
end
