class CreateFlyoverCommentsFlags < ActiveRecord::Migration
  def change
    create_table :flyover_comments_flags do |t|
      t.references :comment, index: true
      t.references FlyoverComments.user_class_symbol, index: true

      t.timestamps null: false
    end
  end
end
