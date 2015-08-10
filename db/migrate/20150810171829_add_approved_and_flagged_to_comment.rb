class AddApprovedAndFlaggedToComment < ActiveRecord::Migration
  def change
    add_column :flyover_comments_flags, :reviewed, :boolean, default: false
  end
end
