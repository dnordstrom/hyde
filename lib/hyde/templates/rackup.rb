require "hyde"

app = Rack::Builder.new do
  Hyde::WardenSetup.run
  
  use Rack::Session::Cookie, secret: rand(36**(16)).to_s(36) # Length of string is 16.
  use Rack::ShowExceptions
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = Hyde::Managers::Auth.new
  end

  run Hyde::Application.new
end

Rack::Server.start(app: app, Port: 5000)
