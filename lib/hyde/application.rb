module Hyde
  class Application
    include Hyde::PathHelper
    include Hyde::TemplateHelper
    include Hyde::ResponseHelper
    include Hyde::RequestHelper
    include Hyde::MiddlewareHelper

    def initialize
      use Hyde::Managers::Preview, "post? && !params['preview'].nil?"
      use Hyde::Managers::Deploy, /^\/.+\/deploy$/
      use Hyde::Managers::Static, /^\/gui/
      use Hyde::Managers::Auth, /^\/auth/
      use Hyde::Managers::Post,
        "post? && (!params['delete'].nil? || !params['save'].nil?)"

      Hyde::DSL.load
    end

    def call(env)
      setup_environment(env)
      reset_notice

      return middleware if middleware_responds?
      
      if env["warden"].authenticated?
        if !current_site
          notice :select_site
        elsif !current_dir
          notice :select_dir
        end
      end

      # If user has selected a content directory but no file, we
      # want to display the "new file" form with textarea having
      # the content of a blank file with YAML header.
      if current_dir && !current_file
        opened_file( StringIO.new("---\nlayout: \ntitle: \n---\n") )
      end

      respond_with current_template
    end
  end
end
