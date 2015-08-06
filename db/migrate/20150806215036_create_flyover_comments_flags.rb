class CreateFlyoverCommentsFlags < ActiveRecord::Migration
  def change
    create_table :flyover_comments_flags do |t|
      t.references :comment, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :flyover_comments_flags, :comments
    add_foreign_key :flyover_comments_flags, :users
  end
end
