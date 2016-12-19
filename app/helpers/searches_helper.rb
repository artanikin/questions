module SearchesHelper
  def searches_elements(items)
    results = []
    items.each do |item|
      results << content_tag(:div, class: "search-item") do
        case item.class.name
        when "Question" then question_element(item)
        when "Answer"   then answer_element(item)
        when "Comment"  then comment_element(item)
        when "User"     then user_element(item)
        end
      end
    end
    results.join.html_safe
  end

  private

  def question_element(item)
    link_to(question_path(item)) do
      content_tag(:h3, item.title) +
      content_tag(:p, item.body)
    end
  end

  def answer_element(item)
    link_to(question_path(item.question_id)) do
      content_tag(:p, item.body)
    end
  end

  def comment_element(item)
    if item.commentable_type == "Question"
      path = question_path(item.commentable_id)
    else item.commentable_type == "Answer"
      path = question_path(item.commentable.question_id)
    end

    link_to(path) do
      content_tag(:p, item.body)
    end
  end

  def user_element(item)
    link_to("#") do
      content_tag(:p, item.email)
    end
  end
end
