class Search
  def self.search(q, object="all")
    if available_objects.include?(object)
      object.classify.constantize.search q
    else
      ThinkingSphinx.search q
    end
  end

  def self.available_objects
    %w(question answer comment author)
  end

  def self.items_for_select
    [
      ["All", "all"],
      ["Questions", "question"],
      ["Answers", "answer"],
      ["Comments", "comment"],
      ["Author", "user"]
    ]
  end
end
