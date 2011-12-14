module Hyde
  module Managers
    class Post
      include Hyde::PathHelper
      include Hyde::TemplateHelper
      include Hyde::RequestHelper

      def call(env)
        setup_environment(env, test_mode = true)

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
    end
  end
end
