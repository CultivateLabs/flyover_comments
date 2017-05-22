class AddReasonToFlyoverCommentsFlag < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_flags, :reason, :text
  end
end
