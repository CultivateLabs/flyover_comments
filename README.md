# FlyoverComments

FlyoverComments is a Rails engine that provides full-stack commenting capabilities.


## Pre-requisites

1. Devise or similar user authentication system, which provides a ```current_user``` method to controllers and views.

## Usage

Add comments to your commentable model:
```
class Post < ActiveRecord::Base
  belongs_to :user
  flyover_commentable
end
```

You can the use view helpers to display the comment form and list. In both cases, you need to pass an instance of your ```flyover_commentable``` model to the heper.

To display the new comment form:
```
<%= flyover_comment_form(@post) %>
```

To display the list of comments:
```
<%= flyover_comments_list(@post) %>
```

## Commenter name

In order, FlyoverComments will try the following to display the commenter name:

1. ```user#flyover_comments_name```. If you want to override what is displayed for the commenter name, add this method to your user class.

2. ```user#name```

3. ```user#full_name```

4. ```user#email```