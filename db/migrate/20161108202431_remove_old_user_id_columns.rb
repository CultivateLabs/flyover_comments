class RemoveOldUserIdColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :flyover_comments_comments, "#{FlyoverComments.user_class_underscore}_id", :integer
    remove_column :flyover_comments_votes, "#{FlyoverComments.user_class_underscore}_id", :integer
    remove_column :flyover_comments_flags, "#{FlyoverComments.user_class_underscore}_id", :integer
  end
end
