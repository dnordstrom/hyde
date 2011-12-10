module Hyde
  class Application
    def initialize
      @root = File.expand_path(File.dirname(__FILE__), "gui")
      @gui = Rack::Directory.new @root
      @configs = {}
      @templates = {}
      config_blocks = {}

      # Load configuration files.
      Dir.glob("hyde/*.rb").each do |config|
        config_blocks.merge!( Hyde::DSL.load File.new(config) )
      end

      # Create configuration objects from loaded blocks.
      config_blocks.each do |site, block|
        @configs[site] = Hyde::Configuration.new(site, block)
      end
    end

    def call(env)
      # Pass request to static file handler if path matches "/gui".
      return @gui.call(env) if env["PATH_INFO"].to_s =~ /^\/gui/
      
      # Get array of requested path.
      @path = env['PATH_INFO'].split("/")

      # Get selected site and its contents.
      @site = @path[1].nil? ? nil : @path[1]
      @config = @configs[@site].nil? ? nil : @configs[@site]
      @files = @config.files

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
