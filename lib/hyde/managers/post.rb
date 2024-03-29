module Hyde
  module Managers
    class Post
      include Hyde::PathHelper
      include Hyde::TemplateHelper
      include Hyde::RequestHelper
      include Hyde::ResponseHelper

      def call(env)
        setup_environment(env)
        reset_notice

        # Return response with notice if necessary variables aren't available.
        if params["file"].nil? || params["content"].nil? || !current_site || !current_dir
          notice :save_fail
          return respond_with current_template
        end

        return delete_file unless params["delete"].nil?

        current_file === "new" ? create_file : save_file
      end

      def create_file
        path = File.join(current_config.site, current_dir, params["file"])
        new_uri = File.join("/", current_site, current_dir, params["file"])

        File.open(path, "w") do |file|
          file.write( params["content"] )
        end

        redirect_to new_uri, :save_success
      end

      def save_file
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

          return redirect_to new_uri, :save_success
        end

        # Respond as usual if file was not moved.
        notice :save_success
        respond_with current_template
      end

      def delete_file
        file = File.join(current_config.site, current_dir, current_file)

        File.delete(file)

        redirect_to "/#{current_site}/#{current_dir}", :delete_success
      end
    end
  end
end
