require 'rails_helper'

module FlyoverComments
  RSpec.describe LinkParsing do
    
    describe "#parse_links" do
      it "identifies links starting with http://" do
        widget = Widget.new("This is a string containing a link like http://www.google.com that should be identified")
        links = widget.parse_links(:description)
        expect(links).to eq(["http://www.google.com"])
      end
      
      it "identifies links starting with www." do
        widget = Widget.new("This is a string containing a link like www.google.com that should be identified")
        links = widget.parse_links(:description)
        expect(links).to eq(["www.google.com"])
      end
      
      it "identifies links starting with https://" do
        widget = Widget.new("This is a string containing a link like https://google.com that should be identified")
        links = widget.parse_links(:description)
        expect(links).to eq(["https://google.com"])
      end
      
      it "identifies multiple links in the same string" do
        widget = Widget.new("This is a string containing https://google.com and http://www.google.com that should be identified but also www.google.com")
        links = widget.parse_links(:description)
        expect(links).to eq(["https://google.com", "http://www.google.com", "www.google.com"])
      end
    end
    
    describe "#has_links?" do
      it "returns true when a link is present" do
        widget = Widget.new("This is a string containing a link like http://www.google.com that should be identified")
        expect(widget.contains_links?(:description)).to eq(true)
      end
      
      it "returns false when no link is present" do
        widget = Widget.new("This is a string containing no link")
        expect(widget.contains_links?(:description)).to eq(false)
      end
    end
    
    describe "add_html_tags_to_detected_links" do
      it "adds link tags to all the links detected in the string" do
        widget = Widget.new
        val = widget.add_html_tags_to_detected_links("This is a string containing https://google.com and http://www.google.com that should be identified but also www.google.com")
        expect(val).to eq("This is a string containing <a href=\"https://google.com\">https://google.com</a> and <a href=\"http://www.google.com\">http://www.google.com</a> that should be identified but also <a href=\"http://www.google.com\">www.google.com</a>")
      end
    end
    
  end
end