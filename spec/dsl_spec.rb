require "hyde"
require "spec_helper"

include SpecHelper

describe Hyde::DSL do
  describe "#load" do
    before do
      Dir.stub!(:glob).and_return( ["a_file.rb"] )
      File.stub!(:new).and_return(sample_config_file)
    end

    before :each do
      Hyde::DSL.instance_eval { @dsl = nil }
    end

    it "should store all 'configure' blocks" do
      Hyde::DSL.load.configs.length.should === 1
    end

    it "should call configure method" do
      Hyde::DSL.any_instance.should_receive(:configure)
      Hyde::DSL.load
    end
    
    it "should call user method" do
      Hyde::DSL.any_instance.should_receive(:user)
      Hyde::DSL.load
    end
  end
end
