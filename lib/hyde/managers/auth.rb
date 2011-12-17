module Hyde
  module Managers
    # Manages authentication requests, as well as Warden
    # authentication failures.
    class Auth
      include Hyde::PathHelper
      include Hyde::TemplateHelper
      include Hyde::RequestHelper
      include Hyde::ResponseHelper

      # Authentication method used as the Warden :password
      # strategy. Returns user object (a Hash) on success, and
      # otherwise notifies Warden about the failure and passes a
      # notice message that will be displayed on the page.
      def authenticate(username, password)
        user = Hyde::DSL.load.users[username.to_sym]

        print "\n\n#{user.inspect}\n\n"

        if !user.nil? && user[:password].to_s === password
          user
        else
          throw :warden
        end
      end
      
      # Authenticates user if not yet logged in. If user is already
      # logged in, he is instead logged out. Both actions are using
      # the same path (e.g. /^\/auth/) for convenience.
      def call(env)
        setup_environment(env)
        
        # Path info "/unauthenticated" means Warden is calling
        # this app as its failure app, and we simply want to
        # display the login page with a notice.
        unless @env["PATH_INFO"] === "/unauthenticated"
          if env["warden"].authenticated?
            env["warden"].logout
          else
            env["warden"].authenticate!(:password)
          end
        end

        redirect_to "/", :auth_fail
      end
    end
  end
end
