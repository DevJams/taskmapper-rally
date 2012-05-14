require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Rally::Ticket do
  before(:all) do 
    @project_name = "Sample Project"
    @project_id = 2712835688
    @ticket_id = 2780205298
    @ticket_title = "Safari email alert has wrong subject"
    @ticket_description = "The safari email alert message is 'Safari Email.' It should be 'Awesome Safari Email.'"
    @ticket_requestor = "sfw@simeonfosterwillbanks.com"
    @ticket_resolution = "Defined"
    @ticket_status = "Submitted"
    @ticket_created_at = "Sat Jan 29 19:35:56 UTC 2011"
    VCR.use_cassette('rally_tickets') do 
      @taskmapper = TaskMapper.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                       :username => 'taskmapper-rally@simeonfosterwillbanks.com', 
                                       :password => 'Password'})
      @project = @taskmapper.project(@project_id)
    end

  end

  before(:each) do
    @klass = TaskMapper::Provider::Rally::Ticket
  end

  it "should return the ticket class" do
    VCR.use_cassette('tickets_class') { @project.ticket.should == @klass }
  end

  it "should be able to load all tickets" do 
    VCR.use_cassette('all_tickets') { @tickets = @project.tickets }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on array of id's" do
    VCR.use_cassette('tickets_by_ids') { @tickets = @project.tickets([@ticket_id]) }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.description.should == @ticket_description
    @tickets.first.project_id.should == @project_id
    @tickets.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @ticket_created_at
  end

  it "should be able to load a single ticket based on attributes"  do
    VCR.use_cassette('ticket_by_attributes') { @ticket = @project.ticket(:id => @ticket_id) }
    @ticket.should be_an_instance_of(@klass)
    @ticket.description.should == @ticket_description
    @ticket.project_id.should == @project_id
    @ticket.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @ticket_created_at
  end

  it "should be able to load all tickets using attributes" do
    VCR.use_cassette('tickets_by_attributes') { @tickets = @project.tickets(:status => "Submitted") }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.description.should == @ticket_description
    @tickets.first.project_id.should == @project_id
    @tickets.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @ticket_created_at
  end

  it "should be able to load all tickets of a given type" do
    VCR.use_cassette('tickets_by_defect') { @tickets = @project.tickets(:type_as_symbol => :defect) }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.description.should == @ticket_description
    @tickets.first.project_id.should == @project_id
    @tickets.collect do |tick|
      tick.type_as_symbol.should == :defect
    end

    VCR.use_cassette('tickets_by_task') { @tickets = @project.tickets(:type_as_symbol => :task) }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.project_id.should == @project_id
    @tickets.collect do |tick|
      tick.type_as_symbol.should == :task
    end

    VCR.use_cassette('tickets_by_hierachial') { @tickets = @project.tickets(:type_as_symbol => :hierarchical_requirement) }
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.project_id.should == @project_id
    @tickets.collect do |tick|
      tick.type_as_symbol.should == :hierarchical_requirement
    end

  end

  it "should be able to update and save a ticket" do
    VCR.use_cassette('ticket_update') { @ticket = @project.ticket(@ticket_id) }
    @ticket.description = "A brand new awesome description"
    @ticket.status = "Closed"
    VCR.use_cassette('ticket_save') { @ticket.save }
    @ticket.description.should == 'A brand new awesome description'
    @ticket.status.should == "Closed"
    @ticket.description = @ticket_description
    @ticket.status = @ticket_status
    VCR.use_cassette('ticket_save') { @ticket.save }
    @ticket.description.should == @ticket_description
  end

  it "should be able to create a new ticket" do
    VCR.use_cassette('save_ticket') { @ticket = @project.ticket!({:title => 'Testing', :description => "Here we go"}) }
    @ticket.should be_an_instance_of(@klass)
    @ticket.type_as_symbol.should == :defect
  end

  it "should be able to create a new ticket" do
    VCR.use_cassette('save_task_ticket') { @ticket = @project.ticket!({:title => 'TaskTesting', :description => "Here we go tasks", :type_as_symbol => :task, :status => "Defined", :work_product => @project.tickets(:type_as_symbol => :defect).first.oid}) }
    @ticket.should be_an_instance_of(@klass)
    @ticket.type_as_symbol.should == :task
  end


end
