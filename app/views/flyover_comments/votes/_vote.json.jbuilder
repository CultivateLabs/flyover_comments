json.extract! vote,
              :id,
              :ident_user_id,
              :comment_id,
              :value,
              :created_at,
              :updated_at

if @include_buttons_html
  json.updated_buttons_html vote_flyover_comment_buttons(vote.comment, vote)
end
