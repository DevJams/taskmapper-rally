require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Rally::Project do

  before(:all) do 
    VCR.use_cassette('rally') do 
      @taskmapper = taskmapper.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                       :username => 'taskmapper-rally@simeonfosterwillbanks.com', 
                                       :password => 'Password'})
    end
    @klass = taskmapper::Provider::Rally::Project
  end

  before(:each) do
    @project_name = "Sample Project"
    @project_id = 2712835688
    @project_created_at = "Tue Jan 18 15:40:28 UTC 2011"
  end

  it "should be able to load all projects" do
    VCR.use_cassette('rally_projects') do 
      @taskmapper.projects.should be_an_instance_of(Array)
      @taskmapper.projects.first.should be_an_instance_of(@klass)
    end
  end

  it "should be able to find a project by id" do
    VCR.use_cassette('rally_by_id') { @project = @taskmapper.project(@project_id) }
    @project.should be_an_instance_of(@klass)
    @project.name.should == @project_name
    @project.id.should == @project_id
    @project.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @project_created_at
  end

  it "should be able to load all projects from an array of ids" do 
    VCR.use_cassette('rally_projects_by_ids') { @projects = @taskmapper.projects([@project_id]) }
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)    
    @projects.first.name.should == @project_name
    @projects.first.id.should == @project_id    
    @projects.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @project_created_at
  end

  it "should be able to load all projects from attributes" do 
    VCR.use_cassette('rally_projects_by_attributes') { @projects = @taskmapper.projects(:name => @project_name)}
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.name.should == @project_name
    @projects.first.id.should == @project_id    
    @projects.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @project_created_at
  end

  it "should be able to load projects using the find method" do
    VCR.use_cassette('rally_project_return_class') do 
      @taskmapper.project.should == @klass
      @taskmapper.project.find(@project_id).should be_an_instance_of(@klass)
    end
  end

end
