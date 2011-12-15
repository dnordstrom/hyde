module Hyde
  module TemplateHelper
    # Sets notice text if an argument is provided, otherwise
    # returns the notice text. A Symbol can be provided as an
    # argument to set notice to a predetermined value. E.g.:
    #
    # notice :save_success #=> "Successfully saved your file."
    def notice(new_notice = nil)
      @notice ||= false

      @notice = (
        if new_notice.is_a? Symbol
          t(new_notice)
        else
          new_notice.nil? ? @notice : new_notice
        end
      )
    end

    # Reset notice to current_notice if available, otherwise false.
    def reset_notice
      notice (!current_notice ? false : current_notice.to_sym)
    end

    # Returns predefined text snippets based on Symbol argument.
    #
    # TODO: Add localization.
    def t(label)
      notice case label
      when :sites
        "Sites"
      when :content
        "Content"
      when :save_success
        "Successfully saved your file."
      when :save_fail
        "Please fill in both filename and content before saving."
      when :select_site
        "Please <strong>select a site</strong> using the menu bar."
      when :select_dir
        "Please <strong>select a content type</strong> using the menu bar."
      when :deploy_fail
        "Could not deploy, please <strong>select a site</strong> or submit a bug report."
      end
    end

   # Loads appropriate template based on authentication status.
    def current_template
      if !@env["warden"].nil? && @env["warden"].authenticated?
        load_template("application.html.erb")
      else
        load_template("login.html.erb")
      end
    end

    # Loads ERB template file with current class's binding, and return result.
    def load_template(file)
      root = File.join( File.expand_path(File.dirname(__FILE__)), "../templates" )
      ERB.new( File.new("#{root}/#{file}").read ).result(binding)
    end

    def current_config
      @env["hyde.configs"][current_site].nil? ? false : @env["hyde.configs"][current_site]
    end

    def current_files
      return false unless current_dir

      Dir.glob( File.join(current_config.site, current_dir, "*") ).reverse
    end

    def opened_file
      return false unless current_file

      File.new( File.join(current_config.site, current_dir, current_file) )
    end
  end
end
