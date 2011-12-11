module Hyde
  module AuthHelper
    # Analyze request for authentication cookie.
    def logged_in?
      @env["warden"].authenticated?
    end

    def authenticate(username, password)
      if !@users[username.to_sym].nil? && @users[username.to_sym][:password].to_s === password
        @users[username.to_sym]
      else
        false
      end
    end

    def log_in
      @env["warden"].authenticate! :password
    end
  end
end
