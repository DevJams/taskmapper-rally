require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Rally::Comment do
  before(:all) do 
    @project_id = 2712835688
    @ticket_id = 2780205298
    @comment_id = 2988719307
    @comment_author = "sfw@simeonfosterwillbanks.com"
    VCR.use_cassette('rally') do 
      @taskmapper = TaskMapper.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                   :username => 'taskmapper-rally@simeonfosterwillbanks.com', 
                                   :password => 'Password'})

    end
    VCR.use_cassette('rally_by_id') { @project = @taskmapper.project(@project_id) }
    VCR.use_cassette('ticket_by_attributes') { @ticket = @project.ticket(:id => @ticket_id) }
  end

  before(:each) do
    @klass = TaskMapper::Provider::Rally::Comment
  end

  it "should be able to load all comments" do
    VCR.use_cassette('load_all_rally_comments') { @comments = @ticket.comments }
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all comments based on array of ids" do 
    VCR.use_cassette('load_comments_by_ids') { @comments = @ticket.comments([@comment_id]) }
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
    @comments.first.author.should == @comment_author
  end

  it "should be able to load all comments based on attributes" do 
    VCR.use_cassette('load_comments_by_attributes') { @comments = @ticket.comments(:id => @comment_id) }
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
    @comments.first.author.should == @comment_author
  end

  it "should be able to create a new comment" do
    # Add discussion for User Story US8: Order picture package
    VCR.use_cassette('retrieve_ticket')  {@ticket = @project.ticket(:id => 2712836091) }
    VCR.use_cassette('create_comment') { @comment = @ticket.comment!(:body => 'Pictures will be available for purchase!') }
    @comment.should be_an_instance_of(@klass)
  end 

end
