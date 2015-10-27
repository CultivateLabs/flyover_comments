class CreateFlyoverCommentsVotes < ActiveRecord::Migration
  def change
    create_table :flyover_comments_votes do |t|
      t.references :comment, index: true
      t.integer :value
      t.references FlyoverComments.user_class_symbol, index: true

      t.timestamps null: false
    end
  end
end
