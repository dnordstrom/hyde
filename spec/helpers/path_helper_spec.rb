require "hyde"

describe Hyde::PathHelper do
  before do
    # Create dummy app.
    @app = Object.new
    @app.extend(Hyde::PathHelper)
  end

  describe "#use_path" do
    it "should specify a path to be used in other methods" do
      @app.use_path("/some/path/here")

      @app.instance_variable_get(:@path).should === ["some", "path", "here"]
    end
  end

  context "when full path has been set" do
    before { @app.use_path("/site/content/file") }

    describe "#current_site" do
      it "should return currently selected site" do
        @app.current_site.should === "site"
      end
    end

    describe "#current_dir" do
      it "should return currently selected content directory" do
        @app.current_dir.should === "content"
      end
    end

    describe "#current_file" do
      it "should return currently selected file" do
        @app.current_file.should === "file"
      end
    end
  end

  context "when root/empty path has been set" do
    before { @app.use_path("/") }
    
    describe "#current_site" do
      it "should return false" do
        @app.current_site.should be_false
      end
    end

    describe "#current_dir" do
      it "should return false" do
        @app.current_dir.should be_false
      end
    end

    describe "#current_file" do
      it "should return false" do
        @app.current_file.should be_false
      end
    end
  end
end
