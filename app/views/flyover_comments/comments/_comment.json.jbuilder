json.extract! comment,
              :id,
              :commenter_id,
              :commenter_type,
              :content,
              :commentable_id,
              :commentable_type,
              :parent_id,
              :created_at,
              :updated_at

unless local_assigns[:exclude_html]
  json.content_html simple_format comment.content
  json.comment_html render(partial: "flyover_comments/comments/comment", locals: { comment: comment }, formats: [:html])
end
