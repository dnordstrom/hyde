module Hyde
  class Application
    include Hyde::AuthHelper
    include Hyde::PathHelper
    include Hyde::TemplateHelper

    attr_reader :users

    def initialize
      @root = File.expand_path(File.dirname(__FILE__))
      @gui = Rack::Directory.new @root
      
      load_configurations
    end

    def call(env)
      setup_environment(env)
      
      return @gui.call(env) if env["PATH_INFO"].to_s =~ /^\/gui/
      handle_auth if env["PATH_INFO"].to_s =~ /^\/auth/

      if logged_in?
        if !current_site
          notice "Please <strong>select a site</strong> using the menu bar."
        elsif !current_dir
          notice "Please <strong>select a content type</strong> using the menu bar."
        end
      end

      respond
    end

    # Save env, set path, and create a Rack::Request object.
    def setup_environment(env)
      @env = env
      @request = Rack::Request.new(env)
      use_path(env["PATH_INFO"])
    end

    # Load configuration blocks and create configuration objects.
    def load_configurations
      @users = {}
      @configs = {}
      config_blocks = {}
      
      Dir.glob("hyde/*.rb").each do |config|
        results = Hyde::DSL.load File.new(config)

        config_blocks.merge!( results[:configs] )
        @users.merge!( results[:users] )
      end

      config_blocks.each do |site, block|
        @configs[site] = Hyde::Configuration.new(site, &block)
      end
    end

    # Generate Rack response array.
    def respond
      [
        # HTTP status code.
        200,

        # Content type header.
        { "Content-Type" => "text/html" },

        # Response body.
        [ current_template ]
      ]
    end

    # Load ERB template file with app binding, and return result.
    def load_template(file)
      ERB.new( File.new("#{@root}/#{file}").read ).result(binding)
    end
    
    # Return appropriate template result.
    def current_template
      if logged_in?
        load_template("application.html.erb")
      else
        load_template("login.html.erb")
      end
    end

    def handle_auth
      if logged_in?
        @env["warden"].logout
      else
        @env["warden"].authenticate!(:password)
      end
    end

    def current_config
      @configs[current_site].nil? ? false : @configs[current_site]
    end

    def current_files
      return false unless current_dir

      Dir.glob( File.join(current_config.site, current_dir) )
    end
  end
end
