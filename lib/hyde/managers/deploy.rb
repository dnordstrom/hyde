module Hyde
  module Managers
    class Deploy
      include TemplateHelper
      include ResponseHelper
      include RequestHelper

      def call(env)
        return redirect_to "/", :deploy_fail unless current_site

        Dir.chdir(current_config.site)
        output = `jekyll`

        notice "<strong>Deployment procedure executed.</strong><br><br><pre><code>#{output.gsub("\n", "<br>")}</code></pre>"

        respond_with current_template
      end
    end
  end
end
