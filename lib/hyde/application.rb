module Hyde
  class Application
    include Hyde::AuthHelper
    include Hyde::PathHelper
    include Hyde::TemplateHelper
    include Hyde::MiddlewareHelper

    attr_reader :users

    def initialize
      use Hyde::StaticManager, /^\/gui/

      load_configurations
    end

    def call(env)
      setup_environment(env)
      reset_notice
      
      return middleware if middleware_responds?

      return handle_auth if env["PATH_INFO"].to_s =~ /^\/auth/
      return handle_post if @request.post?
      return handle_deploy if env["PATH_INFO"].to_s =~ /\/deploy$/

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

    # Reset notice to current_notice if available, otherwise false.
    def reset_notice
      notice (!current_notice ? false : current_notice.to_sym)
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
      root = File.expand_path( File.dirname(__FILE__) )
      ERB.new( File.new("#{root}/#{file}").read ).result(binding)
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

    def handle_post
      # Return response with notice if necessary variables aren't available.
      if params["file"].nil? || params["content"].nil? || !current_site || !current_dir
        notice "Please fill in both filename and content."
        return respond
      end
      
      # Save new content.
      old_path = File.join(current_config.site, current_dir, current_file)
      File.open(old_path, "w") do |file|
        file.write( params["content"] )
      end

      # Move file to new location filename was modified.
      new_path = File.join(current_config.site, current_dir, params["file"])
      unless new_path === old_path
        FileUtils.mv(old_path, new_path)
        new_uri = File.join("/", current_site, current_dir, params["file"])

        return redirect_to new_uri, :success
      end

      # Respond as usual if file was not moved.
      notice :success
      respond
    end

    def handle_deploy
      return redirect_to "/", :deploy_fail unless current_site

      Dir.chdir(current_config.site)
      output = `jekyll`

      notice "<strong>Deployment procedure executed.</strong><br><br><pre><code>#{output.gsub("\n", "<br>")}</code></pre>"

      respond
    end

    def redirect_to(path, notice = "")
      notice = "/#{notice.to_s}" unless notice === ""

      [
        302,
        { "Content-Type" => "text", "Location" => "#{path + notice}" },
        [ "302 Redirect" ]
      ]
    end

    def current_config
      @configs[current_site].nil? ? false : @configs[current_site]
    end

    def current_files
      return false unless current_dir

      Dir.glob( File.join(current_config.site, current_dir, "*") ).reverse
    end

    def opened_file
      return false unless current_file

      File.new( File.join(current_config.site, current_dir, current_file) )
    end

    # Shortcut to Rack::Request#params.
    def params
      @request.params
    end
  end
end
