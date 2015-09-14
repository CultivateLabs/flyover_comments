class AddReasonToFlyoverCommentsFlag < ActiveRecord::Migration
  def change
    add_column :flyover_comments_flags, :reason, :text
  end
end
