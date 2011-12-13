module Hyde
  class AuthManager
    # Authentication method used as the Warden :password
    # strategy. Returns user object (a Hash) on success, and
    # otherwise notifies Warden about the failure and passes a
    # notice message that will be displayed on the page.
    def authenticate(username, password)
      user = @users[username.to_sym]

      if !user.nil? && user[:password].to_s === password
        user
      else
        throw :warden, notice: "Incorrect username or password, please try again."
      end
    end
    
    # Authenticates user if not yet logged in. If user is already
    # logged in, he is instead logged out. Both actions are using
    # the same path (e.g. /^\/auth/) for convenience.
    def call(env)
      @env = env

      if logged_in?
        env["warden"].logout
      else
        env["warden"].authenticate!(:password)
      end
    end
  end
end
