# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|

  navigation.renderer = SimpleNavigation::Renderer::Bootstrap
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|
    primary.dom_class = 'nav pull-right'
  end

end
