require "hyde"

include SpecHelper
include RequestHelper

describe Hyde::Managers::File do
  before do
    @app = Object.new.extend(Hyde::Managers::File)
  end

  describe "#call" do
    context "when form params have been provided" do
      it "should save file to disk" do
        post "/test_site/_posts/a_post.md", {
          "file" => "a_post.md",
          "content" => "Some text in file."
          "hyde.configs" => { test_site: default_config }
        }

        File.any_instance.should_receive(:open).with("/tmp/test_site/_posts/a_post.md", "w").and_return(true)
      end
    end
  end
end
