class AddChildrenCountToComments < ActiveRecord::Migration[4.2]
  def up
    add_column :flyover_comments_comments, :children_count, :integer, default: 0

    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      ActiveRecord::Base.connection.execute <<-SQL
        update flyover_comments_comments
        set children_count = counts.child_count
        from (
              select parent_id, count(*) as child_count
              from flyover_comments_comments
              group by parent_id
             ) as counts
        where flyover_comments_comments.id = counts.parent_id;
      SQL
    else
      FlyoverComments::Comment.reset_column_information
      FlyoverComments::Comment.find_each do |comment|
        comment.update_attribute(:children_count, comment.children.count)
      end
    end
  end

  def down
    remove_column :flyover_comments_comments, :children_count
  end
end
