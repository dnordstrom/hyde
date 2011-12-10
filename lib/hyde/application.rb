module Hyde
  class Application
    def initialize
      @root = File.expand_path(File.dirname(__FILE__), "gui")
      @gui = Rack::Directory.new @root
      @configs = []
      @templates = {}
      config_blocks = {}

      # Load configuration files.
      Dir.glob("hyde/*.rb").each do |config|
        config_blocks += Hyde::DSL.load File.new(config)
      end

      # Create configuration objects from loaded blocks.
      config_blocks.each do |site, block|
        @configs << Hyde::Configuration.new(site, block)
      end
    end

    def call(env)
      # Pass request to static file handler if path matches "/gui".
      return @gui.call(env) if env["PATH_INFO"].to_s =~ /^\/gui/
      
      # Return Rack compatible response.
      [
        # HTTP status code.
        200,

        # Content type header.
        { "Content-Type" => "text/html" },

        # Response body.
        [ load_template "application.html.erb" ]
      ]
    end

    def load_template(file)
      ERB.new( File.new("#{@root}/#{file}") ).result(binding)
    end
  end
end
