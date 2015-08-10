class AddApprovedAndFlaggedToComment < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :approved, :boolean, default: false
    add_column :flyover_comments_comments, :flagged, :boolean, default: false
  end
end
