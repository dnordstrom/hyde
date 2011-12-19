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

        # We want opened_file() to return the unsaved file
        # contents from params["content"] to see the changes.
        opened_file( StringIO.new(content) )

        if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          content = $'
        end
        
        if current_file =~ /\.(md|markdown)$/
          @preview = BlueCloth::new(content).to_html
        else
          @preview = content
        end

        notice :preview

        respond_with current_template
      end
    end
  end
end
