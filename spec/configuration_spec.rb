require "hyde"

describe Hyde::Configuration do
  before do
    @config = Hyde::Configuration.new :test_site do
      site "/some/path"

      content "/some/path/_posts"
      content "/some/path/_pages"
    end
  end
  
  describe "#new" do
    it "should store site title" do
      @config.title.should === "test_site"
    end
  end

  describe "#site" do
    it "should store path to Jekyll root" do
      @config.site.should === "/some/path"
    end
  end

  describe "#content" do
    it "should store path(s) to content" do
      @config.content.should === [
        "/some/path/_posts",
        "/some/path/_pages"
      ]
    end
  end
end
