Liquify.setup do |config|
  config.register_drop :site, lambda { Site.current }
  config.register_drop :navigation, lambda { Site.current.homepage.pages.published.ordered(Site.current.homepage) }
  config.register_drop :page, lambda { Page.current }
  config.register_drop :parent, lambda { Page.current.parent }
  config.register_drop :homepage, lambda { Site.current.homepage }

  config.register_tag :snippet, SnippetTag
  config.register_tag :comment_for, CommentFor

  config.register_filters HTMLFilters

  # A tag is a class that inherits from Liquify::Tag or Liquid::Tag
  # config.register_tag :tag_name, TagClass

  # A drop is a class that inherits from Liquify::Drop or Liquid::Drop
  # config.register_drop :drop_name, DropClass

  # A filter is a method within a module. Multiple filters can be registered
  # at once within a single module.
  # config.register_filters FiltersModule
end
