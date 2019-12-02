class AddOwnedByFieldsToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_comments, :commenter_id, :integer
    add_column :flyover_comments_comments, :commenter_type, :string

    user_class_underscore = FlyoverComments.user_class_underscore
    FlyoverComments::Comment.update_all(commenter_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize.to_s)

    user_id_sym = "#{user_class_underscore}_id".to_sym

    FlyoverComments::Comment.distinct.pluck(user_id_sym).each do |commenter_id|
      comments_by_user = FlyoverComments::Comment.where(user_id_sym => commenter_id)
      comments_by_user.update_all(commenter_id: commenter_id)
    end
  end
end
