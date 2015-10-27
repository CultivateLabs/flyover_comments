class CreateFlyoverCommentsVotes < ActiveRecord::Migration
  def change
    create_table :flyover_comments_votes do |t|
      t.references :flyover_comments_comment, index: true
      t.integer :value
      t.references FlyoverComments.user_class_symbol, index: true

      t.timestamps null: false
    end
    add_foreign_key :flyover_comments_votes, :flyover_comments_comments
    add_foreign_key :flyover_comments_votes, :user_symbols
  end
end
