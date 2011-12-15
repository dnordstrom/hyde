require "hyde"

describe Hyde::Managers::Auth do
  before do
    # Create dummy app.
    @app = Object.new.extend(Hyde::Managers::Auth)
  end

  describe "#load_sessions" do
    it "should load sessions from temp file" do
    end
  end
end
