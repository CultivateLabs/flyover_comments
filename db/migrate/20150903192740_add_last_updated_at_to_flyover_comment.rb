class AddLastUpdatedAtToFlyoverComment < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_comments, :last_updated_at, :datetime
  end
end
