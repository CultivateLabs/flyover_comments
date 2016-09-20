json.extract! vote,
              :id,
              FlyoverComments.user_class_symbol,
              :comment_id,
              :value,
              :created_at,
              :updated_at

if @include_buttons_html
  json.updated_buttons_html vote_flyover_comment_buttons(vote.comment, vote: vote)
end
