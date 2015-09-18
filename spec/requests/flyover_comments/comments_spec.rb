

require 'rails_helper'

module FlyoverComments
  RSpec.describe CommentsController do

    let(:current_user){ FactoryGirl.create(:user) }

    before do
      allow_any_instance_of(FlyoverComments::CommentsController).to receive(:current_user).and_return(current_user)
    end

    describe "#index" do
      let(:post){ FactoryGirl.create(:post) }

      let(:user0){ FactoryGirl.create(:user) }
      let(:user1){ FactoryGirl.create(:user) }
      let(:user2){ FactoryGirl.create(:user) }

      before do
        20.times do |i|
          content = if i % 2
            "Comment #{i}"
          else
            "Comment #{i} with link http://www.cultivatelabs.com"
          end
          FactoryGirl.create(:comment, commentable: post, content: content, ident_user: send("user#{i%3}"))
        end
      end

      it "gives back a paginated list of comments" do
        get comments_path(commentable_id: post.id, commentable_type: post.class.to_s)
        node = Capybara.string response.body

        post.comments.newest_first.each_with_index do |comment, i|
          if i < 10
            expect(node).to have_selector("#flyover_comment_#{comment.id}")
          else
            expect(node).to_not have_selector("#flyover_comment_#{comment.id}")
          end
        end

        get comments_path(commentable_id: post.id, commentable_type: post.class.to_s, page: 2)
        node = Capybara.string response.body

        post.comments.newest_first.each_with_index do |comment, i|
          if i >= 10
            expect(node).to have_selector("#flyover_comment_#{comment.id}")
          else
            expect(node).to_not have_selector("#flyover_comment_#{comment.id}")
          end
        end
      end

      it "gives back a list of comments with links" do
        get comments_path(commentable_id: post.id, commentable_type: post.class.to_s, with_links: true)
        node = Capybara.string response.body

        node.all(".flyover-comment").each do |comment_node|
          expect(comment_node).to have_link("http://www.cultivatelabs.com", href: "http://www.cultivatelabs.com")
        end
      end

      it "gives back a list of comments filtered by the current user's custom preferences" do
        def current_user.filter_flyover_comments(comments)
          comments.where(ident_user: Ident::User.last)
        end

        get comments_path(commentable_id: post.id, commentable_type: post.class.to_s, filter: "current_user")
        node = Capybara.string response.body

        user = Ident::User.last

        FlyoverComments::Comment.where(ident_user: user).each do |comment|
          expect(node).to have_selector("#flyover_comment_#{comment.id}")
        end
        
        FlyoverComments::Comment.where.not(ident_user: user).each do |comment|
          expect(node).to_not have_selector("#flyover_comment_#{comment.id}")
        end
      end
    end

  end
end
