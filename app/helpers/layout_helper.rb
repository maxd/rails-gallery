module LayoutHelper

  def page_title(value)
    @page_title = value
  end

  # application.html.haml helpers

  def body_attrs
    module_class = controller.class.parent

    namespace = nil

    namespace = "namespace-#{module_class.name}" if module_class.instance_of?(Object)
    page = "page-#{controller_name}"
    action = "action-#{action_name}"

    classes = [namespace, page, action].map {|v| v.parameterize.dasherize if v }
    {class: classes}.merge(@body_attrs || {}) {|key, first, second| first + second }
  end

end
