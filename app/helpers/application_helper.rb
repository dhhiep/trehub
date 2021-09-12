# frozen_string_literal: true

module ApplicationHelper
  def page_name
    [params['action'], params['controller'].singularize].join(' ').gsub('_', ' ').titleize
  end

  def display_boolean(value, text_true = 'Yes', text_false = 'No', class_true: :success, class_false: :danger)
    text, html_class = value ? [text_true, class_true] : [text_false, class_false]

    <<-HTML
      <span class="badge-text badge-text-small #{html_class}">#{text}</span>
    HTML
  end
end
