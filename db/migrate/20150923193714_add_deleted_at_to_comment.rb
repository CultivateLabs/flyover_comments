class AddDeletedAtToComment < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :deleted_at, :datetime
  end
end
