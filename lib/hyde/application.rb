module Hyde
  class Application
    include Hyde::AuthHelper
    include Hyde::PathHelper

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
      @request = Rack::Request.new(env)
      @notice = nil
      @cookies = {}

      # Pass request to static file handler if path matches "/gui".
      return @gui.call(env) if env["PATH_INFO"].to_s =~ /^\/gui/
      
      # Handle login requests by logging in and redirecting to
      # the site root.
      if env["PATH_INFO"].to_s =~ /^\/auth/
        username = @request.params["username"]
        password = @request.params["password"]

        if auth(username, password)
          user_salt = salt(64)
          user_hash = hash(user_salt, password)
          
          @cookies[:hash] = user_hash

          tmp = Tempfile.new("hyde")
          begin
            tmp.write( [ username, salt ].join(":") )
          ensure
            tmp.close
          end
        end
      end

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
        [ current_template ]
      ]
    end

    def load_template(file)
      ERB.new( File.new("#{@root}/#{file}").read ).result(binding)
    end
    
    def current_template
      if logged_in?
        load_template("application.html.erb")
      else
        load_template("login.html.erb")
      end
    end
  end
end
