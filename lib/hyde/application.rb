module Hyde
  class Application
    include Hyde::PathHelper
    include Hyde::TemplateHelper
    include Hyde::ResponseHelper
    include Hyde::RequestHelper
    include Hyde::MiddlewareHelper

    def initialize
      use Hyde::Managers::Static, /^\/gui/
      use Hyde::Managers::Auth, /^\/auth/
      use Hyde::Managers::File, "post?"

      Hyde::DSL.load
    end

    def call(env)
      setup_environment(env)
      reset_notice
      
      return middleware if middleware_responds?

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

    def handle_deploy
      return redirect_to "/", :deploy_fail unless current_site

      Dir.chdir(current_config.site)
      output = `jekyll`

      notice "<strong>Deployment procedure executed.</strong><br><br><pre><code>#{output.gsub("\n", "<br>")}</code></pre>"

      respond_with current_template
    end
  end
end
