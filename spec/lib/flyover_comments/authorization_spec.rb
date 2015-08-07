require 'rails_helper'

module FlyoverComments
  RSpec.describe Authorization do
    class Widget
      include FlyoverComments::Authorization
    end

    describe "can_delete_flyover_comment?" do
      let(:user){ Ident::User.new }
      let(:comment){ double(user: user) }

      it "calls can_delete_flyover_comment? on the passed user if the user defines it" do
        def user.can_delete_flyover_comment?(comment)
          true
        end

        expect(user).to receive(:can_delete_flyover_comment?).with(comment)
        Widget.new.can_delete_flyover_comment?(comment, user)
      end

      it "returns true if user#can_delete_flyover_comment? isn't defined and the comment's user is the passed user" do
        is_allowed = Widget.new.can_delete_flyover_comment?(comment, user)
        expect(is_allowed).to eq(true)
      end

      it "returns false if user#can_delete_flyover_comment? isn't defined and the comment's user is not the passed user" do
        is_allowed = Widget.new.can_delete_flyover_comment?(comment, Ident::User.new)
        expect(is_allowed).to eq(false)
      end
    end

    describe "can_create_flyover_comment?" do
      let(:user){ Ident::User.new }
      let(:comment){ double(user: user) }

      it "calls can_create_flyover_comment? on the passed user if the user defines it" do
        def user.can_create_flyover_comment?(comment)
          true
        end

        expect(user).to receive(:can_create_flyover_comment?).with(comment)
        Widget.new.can_create_flyover_comment?(comment, user)
      end

      it "returns true if user#can_create_flyover_comment? isn't defined and the comment's user is the passed user" do
        is_allowed = Widget.new.can_create_flyover_comment?(comment, user)
        expect(is_allowed).to eq(true)
      end

      it "returns false if user#can_create_flyover_comment? isn't defined and the comment's user is not the passed user" do
        is_allowed = Widget.new.can_create_flyover_comment?(comment, Ident::User.new)
        expect(is_allowed).to eq(false)
      end
    end

    describe "can_flag_flyover_comment?" do
      let(:user){ Ident::User.new }
      let(:comment){ double(user: user) }

      it "calls can_flag_flyover_comment? on the passed user if the user defines it" do
        def user.can_flag_flyover_comment?(comment)
          true
        end

        expect(user).to receive(:can_flag_flyover_comment?).with(comment)
        Widget.new.can_flag_flyover_comment?(comment, user)
      end

      it "returns true if user#can_flag_flyover_comment? isn't defined and the user is logged in" do
        is_allowed = Widget.new.can_flag_flyover_comment?(comment, user)
        expect(is_allowed).to eq(true)
      end

    end

  end
end
