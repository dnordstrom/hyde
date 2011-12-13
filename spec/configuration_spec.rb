require "hyde"

describe Hyde::Configuration do
  before do
    @config = Hyde::Configuration.new :test_site do
      site "/tmp"

      deploy do
        `echo Deployed`
      end

      content "_posts"
      content "_pages"
    end
  end
  
  describe "#new" do
    it "should store site title" do
      @config.title.should === "test_site"
    end
  end

  describe "#site" do
    it "should store path to Jekyll root" do
      @config.site.should === "/tmp"
    end
  end

  describe "#content" do
    it "should store path(s) to content" do
      @config.content.should === [
        "_posts",
        "_pages"
      ]
    end
  end

  describe "#deploy" do
    it "should store a deployment block" do
      @config.instance_variable_get(:@deploy).class.should == Proc
    end
  end

  describe "#run_deploy" do
    it "should run stored configuration block" do
      @config.run_deploy.should =~ /^Deployed/
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
