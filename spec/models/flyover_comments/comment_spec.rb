require 'rails_helper'

module FlyoverComments
  RSpec.describe Comment, :type => :model do

    it "tracks whether there is a link in the comment" do
      post = FactoryGirl.create(:post)
      comment = FlyoverComments::Comment.new(content: "Linked string http://www.cultivatelabs.com", commentable: post, commenter: FactoryGirl.create(:user))
      expect(comment.contains_links).to eq(false)
      comment.save
      comment.reload
      expect(comment.contains_links).to eq(true)
    end

    context "when FlyoverComments.insert_html_tags_for_detected_links = true" do
      before{ FlyoverComments.insert_html_tags_for_detected_links = true }

      it "inserts html tags into links in comment content" do
        comment = FlyoverComments::Comment.new(content: "Linked string http://www.cultivatelabs.com. What about this.asdf")
        expect(comment.content).to eq("Linked string <a target=\"_blank\" href=\"http://www.cultivatelabs.com\">http://www.cultivatelabs.com</a>. What about this.asdf")
      end
    end

    context "when FlyoverComments.insert_html_tags_for_detected_links = false" do
      before{ FlyoverComments.insert_html_tags_for_detected_links = false }
      after{ FlyoverComments.insert_html_tags_for_detected_links = true }

      it "doesn't insert html tags into links in comment content" do
        comment = FlyoverComments::Comment.new(content: "Linked string http://www.cultivatelabs.com")
        expect(comment.content).to eq("Linked string http://www.cultivatelabs.com")
      end
    end


    context "when FlyoverComments.auto_escapes_html_in_comment_content = true" do
      before{ FlyoverComments.auto_escapes_html_in_comment_content = true }

      it "escapes html tags in comment content" do
        comment = FlyoverComments::Comment.new(content: "String with <div class='test'>html tag</div>")
        expect(comment.content).to eq("String with &lt;div class=&#39;test&#39;&gt;html tag&lt;/div&gt;")
      end
    end

    context "when FlyoverComments.auto_escapes_html_in_comment_content = false" do
      before{ FlyoverComments.auto_escapes_html_in_comment_content = false }
      after{ FlyoverComments.auto_escapes_html_in_comment_content = true }

      it "doesn't escape html tags in comment content" do
        comment = FlyoverComments::Comment.new(content: "String with <div class='test'>html tag</div>")
        expect(comment.content).to eq("String with <div class='test'>html tag</div>")
      end
    end
  end
end
