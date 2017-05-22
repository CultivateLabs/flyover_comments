class AddCommenterFieldsToFlagsAndVotes < ActiveRecord::Migration[4.2]
  def change
    add_column :flyover_comments_flags, :flagger_id, :integer
    add_column :flyover_comments_flags, :flagger_type, :string
    add_column :flyover_comments_votes, :voter_id, :integer
    add_column :flyover_comments_votes, :voter_type, :string

    user_class_underscore = FlyoverComments.user_class_underscore
    FlyoverComments::Flag.update_all(flagger_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)
    
    user_id_sym = "#{user_class_underscore}_id".to_sym

    FlyoverComments::Flag.distinct.pluck(user_id_sym).each do |flagger_id|
      flags_by_user = FlyoverComments::Flag.where(user_id_sym => flagger_id)
      flags_by_user.update_all(flagger_id: flagger_id)
    end


    FlyoverComments::Vote.update_all(voter_type: user_class_underscore.split("_").map(&:capitalize).join("::").constantize)

    FlyoverComments::Vote.distinct.pluck(user_id_sym).each do |voter_id|
      votes_by_user = FlyoverComments::Vote.where(user_id_sym => voter_id)
      votes_by_user.update_all(voter_id: voter_id)
    end
  end
end
