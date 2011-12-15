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
    
    # Returns array of filenames within the specified content
    # directory, within the site root. Argument could be a
    # Symbol, String or anything else that has a to_s method.
    #
    # Example:
    #
    #   Hyde::Configuration#files("_posts")
    #   => ["2012-01-01-a-post.md", "2012-01-02-other-post.md"]
    #
    def files(dir)
      filenames = []

      @content.each do |path|
        if path =~ /^#{dir.to_s}$/ 
          Dir.glob("#{site}/#{path}/*").each do |file|
            filenames << File.basename(file)
          end
        end
      end

      filenames.reverse
    end

    def deploy(&block)
      @deploy = block
    end

    def run_deploy
      Dir.chdir(site)

      if @deploy.nil?
        output = `jekyll`
      else
        output = @deploy.call
      end

      output
    end
  end
end
