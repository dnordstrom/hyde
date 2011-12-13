module Hyde
  module TemplateHelper
    # Sets notice text if an argument is provided, otherwise
    # returns the notice text. A Symbol can be provided as an
    # argument to set notice to a predetermined value. E.g.:
    #
    # notice :save_success #=> "Successfully saved your file."
    def notice(new_notice = nil)
      @notice = (
        if new_notice.is_a? Symbol
          t(new_notice)
        else
          new_notice.nil? @notice : new_notice
        end
      )
    end

    # Returns predefined text snippets based on Symbol argument.
    #
    # TODO: Add localization.
    def t(label)
      notice case label
      when :save_success
        "Successfully saved your file."
      when :save_fail
        "Please fill in both filename and content before saving."
      when :select_site
        "Please <strong>select a site</strong> using the menu bar."
      when :select_dir
        "Please <strong>select a content type</strong> using the menu bar."
      end
    end

   # Load appropriate template based on authentication status.
    def current_template
      if logged_in?
        load_template("application.html.erb")
      else
        load_template("login.html.erb")
      end
    end

    # Load ERB template file with current class's binding, and return result.
    def load_template(file)
      root = File.expand_path( File.dirname(__FILE__) )
      ERB.new( File.new("#{root}/#{file}").read ).result(binding)
    end
  end
end
