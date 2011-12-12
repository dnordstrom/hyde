require "hyde"

describe Hyde::AuthHelper do
  before do
    # Create dummy app.
    @app = Object.new
    @app.extend(Hyde::AuthHelper)
  end

  describe "#load_sessions" do
    it "should load sessions from temp file" do
    end
  end
end
