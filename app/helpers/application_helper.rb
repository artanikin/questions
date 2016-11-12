module ApplicationHelper
  def vote_link(obj, vote_type)
    options = {
      remote: true,
      method: :patch,
      data: { type: :json },
      class: "vote_#{vote_type}"
    }

    link_to(polymorphic_path(["vote_#{vote_type}", obj]), options) do
      content_tag(:i, nil, class: "glyphicon glyphicon-chevron-#{vote_type}", aria: { hidden: true })
    end.html_safe
  end
end
