require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskMapper::Provider::Rally" do
  
  before(:each) do 
    @auth = {:url => 'https://community.rallydev.com/slm', 
             :username => 'taskmapper-rally@simeonfosterwillbanks.com', 
             :password => 'Password'}
    VCR.use_cassette('taskmapper_call') { @taskmapper = TaskMapper.new(:rally, @auth) }
  end

  it "should be able to instantiate a new instance directly" do
    VCR.use_cassette('taskmapper_call') { @taskmapper = TaskMapper::Provider::Rally.new(@auth) }
    @taskmapper.should be_an_instance_of(TaskMapper)
    @taskmapper.should be_a_kind_of(TaskMapper::Provider::Rally)
  end

  it "should be able to instantiate a new instance from parent" do
    @taskmapper.should be_an_instance_of(TaskMapper)
    @taskmapper.should be_a_kind_of(TaskMapper::Provider::Rally)
  end

  it "should be a valid instance"

end
