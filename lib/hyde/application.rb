module Hyde
  class Application
    def initialize
      @root = File.expand_path(File.dirname(__FILE__), "gui")
      @gui = Rack::Directory.new @root
      @users = {}
      @configs = []
      @templates = {}
      config_blocks = {}

      # Load configuration files.
      Dir.glob("hyde/*.rb").each do |config|
        results = Hyde::DSL.load File.new(config)

        config_blocks.merge!( results[:configs] )
        @users.merge!( results[:users] )
      end

      # Create configuration objects from loaded blocks.
      config_blocks.each do |site, block|
        @configs << Hyde::Configuration.new(site, &block)
      end
    end

    def call(env)
      print @users.inspect
      # Pass request to static file handler if path matches "/gui".
      return @gui.call(env) if env["PATH_INFO"].to_s =~ /^\/gui/
      
      # Get array of requested path.
      @path = env['PATH_INFO'].split("/")

      # Get selected site and its contents.
      @site = @path[1].nil? ? nil : @path[1]
      @config = @configs.select {|config| config.title === @site}.first
      @content = @path[2].nil? ? nil : @path[2]
      @files = @config.nil? || @content.nil? ? nil : @config.files(@content)
      @filename = @path[3].nil? ? nil : @config.site + "/" + @content + "/" + @path[3]
      @file = File.new(@filename) unless @filename.nil?
      
      # Return Rack compatible response.
      [
        # HTTP status code.
        200,

        # Content type header.
        { "Content-Type" => "text/html" },

        # Response body.
        [ load_template("application.html.erb") ]
      ]
    end

    def load_template(file)
      ERB.new( File.new("#{@root}/#{file}").read ).result(binding)
    end
  end
end
