class AddApprovedAndFlaggedToComment < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :approved, :boolean, default: true
    add_column :flyover_comments_comments, :flagged, :boolean, default: false
  end
end
