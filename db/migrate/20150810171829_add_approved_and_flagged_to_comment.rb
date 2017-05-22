class AddApprovedAndFlaggedToComment < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_flags, :reviewed, :boolean, default: false
  end
end
