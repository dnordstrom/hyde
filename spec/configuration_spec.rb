require "hyde"

describe Hyde::Configuration do
  before do
    @config = Hyde::Configuration.new do
      site "/some/path"

      content "/some/path/_posts"
      content "/some/path/_pages"
    end
  end

  describe "#site" do
    subject { @config }

    it "should store path to Jekyll root" do
      site.should === "/some/path"
    end
  end

  describe "#content" do
    it "should store path(s) to content" do
      content.should === [
        "/some/path/_posts",
        "/some/path/_pages"
      ]
    end
  end
end
