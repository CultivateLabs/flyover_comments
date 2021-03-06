# FlyoverComments

FlyoverComments is a Rails engine that provides full-stack commenting capabilities. It is built and maintained by [FlyoverWorks](http://www.flyoverworks.com) / [@flyoverworks](http://twitter.com/flyoverworks)

## Pre-requisites

1. Devise or similar user authentication system, which provides a ```current_user``` method to controllers and views.

2. jQuery and Rails' jQuery UJS must be included in your javascript. 

## Setup

Add FlyoverComments to your gemfile:

```
gem 'flyover_comments'
```

Add ```flyover_comments.rb``` to your initializers, defining the name of your user class and the method that returns the current user:
```
FlyoverComments.configure do |config|
  config.user_class = "User"
  config.current_user_method = "current_user"
end
```

## Usage

mount the engine in your routes file:
```
mount FlyoverComments::Engine, at: "/flyover_comments"
```

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

2. ```user#name``` - User's name

3. ```user#full_name``` - User's full name

4. ```user#email``` - User's email

## Comment creation & deletion authorization

By default, any user can create comments and a user can delete only comments that s/he created. If you want to override this behavior, you can add the following methods to your user class and FlyoverComments will default to them. E.g:

```
class User
  def can_delete_flyover_commment?(comment)
    self.is_admin? || comment.user == self
  end

  def can_create_flyover_comment?(comment)
    !self.is_banned_from_commenting?
  end
end
```
