class AddContainsLinksToFlyoverCommentsComments < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_comments, :contains_links, :boolean, default: false
  end
end
