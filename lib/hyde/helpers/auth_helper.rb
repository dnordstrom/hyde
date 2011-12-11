module Hyde
  module AuthHelper
    # Analyze request for authentication cookie.
    def logged_in?
      @env["warden"].authenticated?
    end

    def authenticate(username, password)
      print "CALLING AUTH".inspect
      if !@users[username].nil? && @users[username][:password].to_s === password
        @users[username]
      else
        false
      end
    end

    def log_in
      @env["warden"].authenticate! :password
    end
  end
end
