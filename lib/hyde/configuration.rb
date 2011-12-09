module Hyde
  class Configuration
    def initialize
      @content = []
      @site = ""

      yield if block_given?
    end

    def site(path = nil)
      return @site if path.nil?
      @site = path
    end

    def content(path = nil)
      return @content if path.nil?
      @content << path
    end
  end
end
