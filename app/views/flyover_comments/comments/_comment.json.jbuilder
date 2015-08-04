json.extract! comment,
              :id,
              "#{FlyoverComments.user_class_symbol}_id",
              :content,
              :commentable_id,
              :commentable_type,
              :parent_id,
              :created_at,
              :updated_at

json.comment_html render(partial: "flyover_comments/comments/comment", locals: { comment: comment }, formats: [:html])