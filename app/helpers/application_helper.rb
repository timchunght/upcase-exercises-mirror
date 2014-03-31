module ApplicationHelper
  def content_tag_with_conditional_classes(tag_name, attributes, &block)
    class_names = attributes[:class_names]
    active_class_names = class_names.select { |_, active| active }.keys
    content_tag(tag_name, class: active_class_names.join(' '), &block)
  end
end
