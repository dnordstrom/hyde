module Hyde
  module TemplateHelper
    # Sets notice text if an argument is provided, otherwise
    # returns the notice text. A Symbol can be provided as an
    # argument to set notice to a predetermined value. E.g.:
    #
    # notice :save_success #=> "Successfully saved your file."
    def notice(new_notice = nil)
      @env["hyde.notice"] ||= false

      @env["hyde.notice"] = (
        if new_notice.is_a? Symbol
          t(new_notice)
        else
          new_notice.nil? ? @env["hyde.notice"] : new_notice
        end
      )
    end

    # Reset notice to current_notice if available, otherwise false.
    def reset_notice
      notice (!current_notice ? false : current_notice.to_sym)
    end
    
    # Returns the current notice if specified in URL, or false if
    # not specified. It will look notice after question mark in
    # URL, e.g.:
    #
    # env["PATH_INFO"] = "/some/path?save_success"
    # current_notice
    #   => "Successfully saved your file."
    def current_notice
      path = @env["PATH_INFO"].split("?")
      path[1].nil? ? false : path[1]
    end

    # Returns predefined text snippets based on Symbol argument.
    #
    # TODO: Add localization.
    def t(label)
      case label
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
      when :auth_fail
        "Incorrect username or password, please try again."
      when :preview
        "<strong>Note:</strong> File is not yet saved."
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

    # Loads ERB template file with current class's binding, and
    # returns result.
    def load_template(file)
      root = File.join( File.expand_path(File.dirname(__FILE__)), "../templates" )
      ERB.new( File.new("#{root}/#{file}").read ).result(binding)
    end

    # Returns configuration for current_site if it exists (based on
    # URL), otherwise returns <code>false</code>.
    def current_config
      @env["hyde.configs"][current_site].nil? ? false : @env["hyde.configs"][current_site]
    end

    # Returns array of files in currently selected directory of
    # currently selected site. If no directory has been selected
    # (based on URL), <code>false</code> is returned.
    def current_files
      return false unless current_dir

      Dir.glob( File.join(current_config.site, current_dir, "*") ).reverse
    end

    # Returns a <code>File</code> instance of currently selected
    # file. If no file has been selected, <code>false</code> is
    # returned.
    def opened_file(file = nil)
      return false unless current_file
      
      @env["hyde.opened_file"] = file unless file.nil?

      @env["hyde.opened_file"] ||
        File.new( File.join(current_config.site, current_dir, current_file) )
    end
  end
end
