class AddOwnedByFieldsToComments < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :commenter_id, :integer
    add_column :flyover_comments_comments, :commenter_type, :string

    user_class_underscore = FlyoverComments.user_class_underscore
    FlyoverComments::Comment.update_all(commenter_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)
    FlyoverComments::Comment.all.each do |comment|
      comment.update(commenter_id: comment.send("#{user_class_underscore}_id"))
    end
  end
end
