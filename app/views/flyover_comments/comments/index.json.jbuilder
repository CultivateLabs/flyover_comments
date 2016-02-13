json.comments do
  json.array! @comments, partial: "flyover_comments/comments/comment", as: :comment, locals: { exclude_html: true }
end
