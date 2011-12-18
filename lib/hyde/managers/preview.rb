module Hyde
  module Managers
    class Preview
      include Hyde::PathHelper
      include Hyde::TemplateHelper
      include Hyde::RequestHelper
      include Hyde::ResponseHelper

      def call(env)
        setup_environment(env)

        return empty_response unless current_file
        
        content = params["content"].gsub("\r\n", "\n")
        if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          content = $'
        end

        @preview = BlueCloth::new(content).to_html

        respond_with current_template
      end
    end
  end
end
