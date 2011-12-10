require "hyde"

describe Hyde::DSL do
  before do
    # Example configuration, simulating file
    # IO using StringIO class.
    @sample_config = StringIO.new <<-eos
      configure :test_site do
        site "/some/path"

        content "/some/path/_posts"
        content "/some/path/_pages"
      end

      configure :another_test_site do
        site "/another/path"

        content "/another/path/_articles"
      end
    eos
  end

  describe "#load" do
    it "should store all 'configure' blocks" do
      configs = Hyde::DSL.load @sample_config
      configs.length.should === 2
    end

    it "should call configure method" do
      Hyde::DSL.any_instance.should_receive(:configure).twice
      Hyde::DSL.load @sample_config
    end
  end
end
