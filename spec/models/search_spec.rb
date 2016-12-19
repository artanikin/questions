require "rails_helper"

RSpec.describe Search, type: :model do
  describe ".search" do
    %w(question answer comment user).each do |object|
      it "should call search method for the #{object}" do
        expect(object.classify.constantize).to receive(:search).with("")
        Search.search("", object)
      end
    end

    it "should call global search" do
      expect(ThinkingSphinx).to receive(:search).with("")
      Search.search("", "all")
    end
  end

  describe ".items_for_select" do
    it "return array" do
      search_options = [
        ["All", "all"],
        ["Questions", "question"],
        ["Answers", "answer"],
        ["Comments", "comment"],
        ["Author", "user"]
      ]
      expect(Search.items_for_select).to match_array(search_options)
    end
  end
end
