module Hyde
  class Application
    include Hyde::PathHelper
    include Hyde::TemplateHelper
    include Hyde::ResponseHelper
    include Hyde::RequestHelper
    include Hyde::MiddlewareHelper

    def initialize
      use Hyde::Managers::Deploy, /^\/.+\/deploy$/
      use Hyde::Managers::Static, /^\/gui/
      use Hyde::Managers::Auth, /^\/auth/
      use Hyde::Managers::Post, "post?"

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

      respond_with current_template
    end
  end
end
