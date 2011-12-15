module Hyde
  class WardenSetup
    class << self
      # Sets up Warden authentication strategy that uses
      # configuration files stored on filesystem, and provides
      # session serialization instructions for user objects.
      def run
        Warden::Manager.serialize_into_session do |user|
          user[:username].to_s
        end

        Warden::Manager.serialize_from_session do |username|
          Hyde::DSL.load.users[username.to_sym]
        end

        Warden::Strategies.add(:password) do
          def valid?
            params["username"] && params["password"]
          end

          def authenticate!
            app = Hyde::Managers::Auth.new
            user = app.authenticate(params["username"], params["password"])
            
            user.nil? ?
              fail!("Incorrect username or password, please try again.") : success!(user)
          end
        end
      end
    end
  end
end
