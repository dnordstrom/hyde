module Hyde
  module Managers
    class Preview
      include Hyde::RequestHelper
      include Hyde::ResponseHelper

      def call(env)
        setup_environment(env)

        return empty_response unless current_file

        # TODO: Get posted params, convert to HTML, return.

        respond_with content
      end
    end
  end
end
