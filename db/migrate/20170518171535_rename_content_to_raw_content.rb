class RenameContentToRawContent < ActiveRecord::Migration[5.0]
  def change
    rename_column :flyover_comments_comments, :content, :raw_content
  end
end
