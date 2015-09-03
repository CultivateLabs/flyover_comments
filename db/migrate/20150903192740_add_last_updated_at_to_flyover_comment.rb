class AddLastUpdatedAtToFlyoverComment < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :last_updated_at, :datetime
  end
end
