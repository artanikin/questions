module ApplicationHelper
  def name_flash_method(name)
    case name.to_sym
    when :alert, :error
      'danger'
    else
      'success'
    end
  end

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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
