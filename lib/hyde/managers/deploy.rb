module Hyde
  module Managers
    class Deploy
      include PathHelper
      include TemplateHelper
      include ResponseHelper
      include RequestHelper

      def call(env)
        setup_environment(env)
        return redirect_to "/", :deploy_fail unless current_config
        
        result = current_config.run_deploy

        output = "<strong>Deployment procedure executed.</strong><br><br>"
        output +="<pre><code>#{result.gsub("\n", "<br>")}</code></pre>"

        notice(output)

        respond_with current_template
      end
    end
  end
end
