module Hyde
  class Configuration
    def initialize(title, &block)
      @content = []
      @site = ""
      @title = title.to_s
      
      # Evaluate DSL block against configuration object,
      # setting the site path, content paths etc.
      instance_eval(&block)
    end

    def site(path = nil)
      return @site if path.nil?
      @site = path
    end

    def content(path = nil)
      return @content if path.nil?
      @content << path
    end

    # Makes it possible to set site title from within
    # the DSL block instead of as argument to constructor.
    def title(title = nil)
      return @title if title.nil?
      @title = title
    end
  end
end
