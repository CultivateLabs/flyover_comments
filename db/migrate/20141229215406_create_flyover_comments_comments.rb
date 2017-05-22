class CreateFlyoverCommentsComments < ActiveRecord::Migration[4.2]
  def change
    create_table :flyover_comments_comments do |t|
      t.text :content
      t.references FlyoverComments.user_class_symbol, index: true
      t.references :commentable, polymorphic: true, index: {name: "idx_flyover_comments_comments_commentable_type_commentable_id"}
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
