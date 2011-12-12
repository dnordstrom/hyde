require "hyde"

describe Hyde::TemplateHelper do
  before { @app = Object.new.extend(Hyde::TemplateHelper) }

  describe "#notice" do
    before { @app.notice "Sample notice" }

    it "should set notice" do
      @app.instance_variable_get(:@notice).should === "Sample notice"
    end

    it "should return notice" do
      @app.notice.should === "Sample notice"
    end
  end
end
