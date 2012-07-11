require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Rally::Project do

  let(:tm) do 
    VCR.use_cassette('rally') do 
      TaskMapper.new(:rally, {:url => 'https://rally1.rallydev.com/slm', :username => 'rafael@hybridgroup.com', :password => 'admin123456'}) 
    end
  end
  let(:project_class) { TaskMapper::Provider::Rally::Project }
  let(:project_name) { 'Sample Project' }
  let(:project_id) { 1 }

  describe "Retrieving projects" do 
    context "when #projects" do 
      subject do 
        VCR.use_cassette('rally_projects') do 
          tm.projects 
        end
      end 
      it { should be_an_instance_of Array }

      context "when #projects.first" do 
        subject do
          VCR.use_cassette('rally_projects') do 
            tm.projects.first
          end
        end 
        it { should be_an_instance_of project_class }
      end
    end
  end

  it "should be able to find a project by id" do
    pending
    VCR.use_cassette('rally_by_id') { @project = @taskmapper.project(@project_id) }
    @project.should be_an_instance_of(@klass)
    @project.name.should == @project_name
    @project.id.should == @project_id
    @project.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @project_created_at
  end

  it "should be able to load all projects from an array of ids" do 
    pending
    VCR.use_cassette('rally_projects_by_ids') { @projects = @taskmapper.projects([@project_id]) }
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)    
    @projects.first.name.should == @project_name
    @projects.first.id.should == @project_id    
    @projects.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @project_created_at
  end

  it "should be able to load all projects from attributes" do 
    pending
    VCR.use_cassette('rally_projects_by_attributes') { @projects = @taskmapper.projects(:name => @project_name)}
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.name.should == @project_name
    @projects.first.id.should == @project_id    
    @projects.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @project_created_at
  end

  it "should be able to load projects using the find method" do
    pending
    VCR.use_cassette('rally_project_return_class') do 
      @taskmapper.project.should == @klass
      @taskmapper.project.find(@project_id).should be_an_instance_of(@klass)
    end
  end
end
