class CreateFlyoverCommentsComments < ActiveRecord::Migration
  def change
    create_table :flyover_comments_comments do |t|
      t.text :content
      t.references :user, index: true
      t.references :commentable, polymorphic: true, index: {name: "idx_flyover_comments_comments_commentable_type_commentable_id"}
      t.references :parent, index: true

      t.timestamps null: false
    end
    add_foreign_key :flyover_comments_comments, :users
    add_foreign_key :flyover_comments_comments, :parents
  end
end
