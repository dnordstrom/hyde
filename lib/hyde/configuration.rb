module Hyde
  class Configuration
    # Sets up site title and evaluates a DSL config block that
    # can specify content paths, deployment procedure etc.
    def initialize(title, &block)
      @content = []
      @site = ""
      @title = title.to_s
      
      # Evaluate DSL block against configuration object,
      # setting the site path, content paths etc.
      instance_eval(&block)
    end

    # DSL method and accessor. If called with argument, it sets
    # the path to the site root, for file editing and deployment
    # procedure. If no path is provided as argument, the method
    # simply returns the <code>@path</code> instance variable.
    def site(path = nil)
      return @site if path.nil?
      @site = path
    end

    # DSL method and accessor for specifying content directories
    # within the site root. When called with argument, it adds a
    # content directory to the <code>@content</code> array. If
    # called without any argument, the method returns the array.
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

    # Stores a block containing deployment prodecure for the
    # particular configuration. The return value will be
    # outputted in the page template after deployment.
    def deploy(&block)
      @deploy = block
    end

    # Runs deployment block. If no block has been specified, the
    # default <code>jekyll</code> command will be run instead.
    # Return value of block (or command) will be returned and
    # printed in the page template after deployment.
    def run_deploy
      Dir.chdir(site)

      if @deploy.nil?
        # Default deployment command.
        output = `jekyll`
      else
        output = @deploy.call
      end

      output
    end
  end
end
