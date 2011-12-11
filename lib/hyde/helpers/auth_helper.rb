module Hyde
  module AuthHelper
    # Analyze request for authentication cookie.
    def logged_in?(request)
      false
    end

    # Load auth sessions from temp file.
    def load_sessions(file = "hyde")
      tmp = Tempfile.new(file)
      sessions = {}

      begin
        while(line = tmp.gets)
          data = line.split(":")
          sessions[ data[0] ] = data[1]
        end
      ensure
        tmp.close
      end

      sessions
    end

    def salt(length = 64)
      Array.new(length/2) { rand(256) }.pack('C*').unpack('H*').first
    end

    def hash(password, salt)
      Digest::SHA256.hexdigest("password=#{password}&salt=#{@password_salt}")
    end
  end
end
