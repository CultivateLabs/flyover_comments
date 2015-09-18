class AddContainsLinksToFlyoverCommentsComments < ActiveRecord::Migration
  def change
    add_column :flyover_comments_comments, :contains_links, :boolean, default: false
  end
end
