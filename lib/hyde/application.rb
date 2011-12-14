module Hyde
  class Application
    include Hyde::PathHelper
    include Hyde::TemplateHelper
    include Hyde::ResponseHelper
    include Hyde::MiddlewareHelper

    def initialize
      use Hyde::Managers::Static, /^\/gui/
      use Hyde::Managers::Auth, /^\/auth/

      Hyde::DSL.load
    end

    def call(env)
      setup_environment(env)
      reset_notice
      
      return middleware if middleware_responds?

      return handle_post if @env["hyde.request"].post?
      return handle_deploy if env["PATH_INFO"].to_s =~ /\/deploy$/

      if env["warden"].authenticated?
        if !current_site
          notice "Please <strong>select a site</strong> using the menu bar."
        elsif !current_dir
          notice "Please <strong>select a content type</strong> using the menu bar."
        end
      end

      respond_with current_template
    end

    # Save env, set path, and create a Rack::Request object.
    def setup_environment(env)
      @env = env
      @env["hyde.users"] = Hyde::DSL.load.users
      @env["hyde.configs"] = Hyde::DSL.load.configs
      @env["hyde.request"] = Rack::Request.new(env)

      use_path(env["PATH_INFO"])
    end

    # Reset notice to current_notice if available, otherwise false.
    def reset_notice
      notice (!current_notice ? false : current_notice.to_sym)
    end

    def handle_post
      # Return response with notice if necessary variables aren't available.
      if params["file"].nil? || params["content"].nil? || !current_site || !current_dir
        notice "Please fill in both filename and content."
        return respond_with current_template
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
      respond_with current_template
    end

    def handle_deploy
      return redirect_to "/", :deploy_fail unless current_site

      Dir.chdir(current_config.site)
      output = `jekyll`

      notice "<strong>Deployment procedure executed.</strong><br><br><pre><code>#{output.gsub("\n", "<br>")}</code></pre>"

      respond_with current_template
    end

    def current_config
      @env["hyde.configs"][current_site].nil? ? false : @env["hyde.configs"][current_site]
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
      @env["hyde.request"].params
    end
  end
end
