require "hyde/version"
require "hyde/helpers/path_helper"
require "hyde/helpers/auth_helper"
require "hyde/application"
require "hyde/dsl"
require "hyde/configuration"
require "hyde/warden"
require "warden"

Warden::Manager.serialize_into_session do |user|
  user[:username]
end

Warden::Manager.serialize_from_session do |username|
  app = Hyde::Application.new
  app.users[:username]
end

Warden::Strategies.add(:password) do
  def valid?
    params[:username] && params[:password]
  end

  def authenticate!
    app = Hyde::Application.new
    user = app.authenticate(params[:username], params[:password])
    
    user.nil? ?
      fail!("Incorrect username or password, please try again.") : success!(user)
  end
end
