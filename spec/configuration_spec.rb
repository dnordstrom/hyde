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

  describe "#files" do
    it "should return array of files in specified content directory" do
      Dir.should_receive(:glob).and_return([
        "2012-01-01-some-content-file.markdown",
        "2012-01-02-another-content-file.html"
      ])

      @config.files(:_posts).length === 2
    end
  end
end
