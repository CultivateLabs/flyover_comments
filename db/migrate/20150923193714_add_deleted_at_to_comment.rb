class AddDeletedAtToComment < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_comments, :deleted_at, :datetime
  end
end
