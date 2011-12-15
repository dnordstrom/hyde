require "hyde"
require_relative "../spec_helper"

include SpecHelper
include RequestHelper

describe Hyde::Managers::Post do
  before do
    @app = Hyde::Managers::Post.new
    FileUtils.mkdir_p("/tmp/_posts")
  end

  after do
    FileUtils.rm_r("/tmp/_posts")
  end

  describe "#call" do
    context "when form params have been provided" do
      it "should save file to disk" do
        File.should_receive(:open).with("/tmp/_posts/a_post.md", "w")

        post "/test_site/_posts/a_post.md", {
          "file" => "a_post.md",
          "content" => "Some text in file."
        }
      end
    end
  end
end
