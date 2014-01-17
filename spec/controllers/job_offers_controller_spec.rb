require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe JobOffersController do

  # This should return the minimal set of attributes required to create a valid
  # job_offer. As you add validations to job_offer, be sure to
  # adjust the attributes here as well.
  let(:assigned_student) { FactoryGirl.create(:user) }
  let(:chair) { FactoryGirl.create(:chair, name: "Chair") }
  let(:responsible_user) { FactoryGirl.create(:user, chair: chair, role: FactoryGirl.create(:role, :name => "Staff")) }
  let(:completed) {FactoryGirl.create(:job_status, :completed)}
  let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :open), "responsible_user_id" => responsible_user.id } }
  let(:valid_attributes_status_running) {{"title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => FactoryGirl.create(:job_status, :running), "assigned_student_id" => assigned_student.id, "responsible_user_id" => responsible_user.id }}
  let(:valid_attributes_status_completed) {{"title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => completed, "assigned_student_id" => assigned_student.email, "responsible_user_id" => responsible_user.id }}


  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # job_offersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)
    
    @epic = FactoryGirl.create(:chair, name:"EPIC")
    @os = FactoryGirl.create(:chair, name:"OS and Middleware")
    @itas = FactoryGirl.create(:chair, name:"Internet and Systems Technologies")
    @open = FactoryGirl.create(:job_status, name:"open")
  end

  describe "Check if views are rendered" do
    render_views

    it "renders the find results" do
      job_offer = JobOffer.create! valid_attributes
      get :index, ({:chair => @epic.id}), valid_session
      response.should render_template("index")
    end

    it "renders the archive" do
      job_offer = JobOffer.create! valid_attributes
      get :archive, {}, valid_session
      response.should render_template("archive")
    end

    it "renders the jobs found archive" do
      job_offer = JobOffer.create! valid_attributes
      get :archive, ({:search => "Ruby"}), valid_session
      response.should render_template("archive")
    end
  end

  describe "GET index" do
    it "assigns all job_offers as @job_offer-list[:items]" do
      job_offer = JobOffer.create! valid_attributes
      get :index, {}, valid_session
      assigns(:job_offers_list)[:items].should eq([job_offer])
    end
  end

  describe "GET archive" do
    it "assigns all archive job_offers as @job_offerlist[:items]" do
      job_offer = JobOffer.create! valid_attributes_status_completed
      get :archive, {}, valid_session
      assigns(:job_offers_list)[:items].should eq([job_offer])
    end

    it "does not assign non-completed jobs" do
      job_offer = JobOffer.create! valid_attributes
      get :archive, {}, valid_session
      assert assigns(:job_offers_list)[:items].empty?
    end
  end

  describe "GET show" do
    it "assigns the requested job_offer as @job_offer" do
      job_offer = JobOffer.create! valid_attributes
      get :show, {:id => job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(job_offer)
    end

    it "assigns a possible applications as @application" do
      user = FactoryGirl.create(:user)
      sign_in user

      job_offer = JobOffer.create! valid_attributes
      application = FactoryGirl.create(:application, user: user, job_offer: job_offer)
      get :show, {:id => job_offer.to_param}, valid_session
      assigns(:application).should eq(application)
    end
  end

  describe "GET new" do
    it "assigns a new job_offer as @job_offer" do
      sign_in responsible_user
      get :new, {}, valid_session
      assigns(:job_offer).should be_a_new(JobOffer)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_offer as @job_offer" do
      job_offer = JobOffer.create! valid_attributes
      get :edit, {:id => job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(job_offer)
    end

    it "only allows the responsible user to edit" do
      job_offer = JobOffer.create! valid_attributes
      job_offer.responsible_user = FactoryGirl.create(:user)
      job_offer.save
      get :edit, {:id => job_offer.to_param}, valid_session
      response.should redirect_to(job_offer)
    end
  end

  describe "GET find" do
    it "assigns @job_offers_list[:items] to all job offers with the chair EPIC" do

      FactoryGirl.create(:job_offer, chair: @itas, status: @open)
      FactoryGirl.create(:job_offer, chair: @epic, status: @open)
      FactoryGirl.create(:job_offer, chair: @os, status: @open)
      FactoryGirl.create(:job_offer, chair: @epic, status: @open)

      job_offers = JobOffer.filter_chair(@epic.id)
      get :index, ({:chair => @epic.id}), valid_session
      assigns(:job_offers_list)[:items].to_a.should =~ (job_offers).to_a
    end
  end

  describe "GET complete" do
    before(:each) do
      @job_offer = JobOffer.create! valid_attributes_status_running
    end

    it "marks jobs as completed if the user is staff of the chair" do 
      completed = FactoryGirl.create(:job_status, :completed)
      sign_in FactoryGirl.create(:user, role: FactoryGirl.create(:role, name: 'Staff', level: 2), chair: @job_offer.chair)
      
      get :complete, {:id => @job_offer.id}
      assigns(:job_offer).status.should eq(completed)      
    end
    it "prohibits user to mark jobs as completed if he is no staff of the chair" do 
      get :complete, {:id => @job_offer.id}, valid_session
      response.should redirect_to(@job_offer)
    end
  end

  describe "GET accept" do 
    let(:deputy) { FactoryGirl.create(:user, chair: chair) }
    before(:each) do
      chair.update(deputy: deputy)
      @job_offer = JobOffer.create! valid_attributes
      @job_offer.update(chair: chair, status: FactoryGirl.create(:job_status))
    end

    it "prohibits user to accept job offers if he is not the deputy" do

      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      get :accept, {id: @job_offer.id}
      response.should redirect_to(job_offers_path)
    end     
    it "accepts job offers" do
      sign_in deputy
      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      @job_offer.save
      get :accept, {:id => @job_offer.id}
      assigns(:job_offer).status.should eq(JobStatus.open) 
      response.should redirect_to(@job_offer)
    end    
  end

  describe "GET decline" do
    let(:deputy) { FactoryGirl.create(:user, chair: chair) }
    before(:each) do
      chair.update(deputy: deputy)
      @job_offer = JobOffer.create! valid_attributes
      @job_offer.update(chair: chair, status: FactoryGirl.create(:job_status))
    end

    it "prohibits user to decline job offers if he is not the deputy" do
      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      @job_offer.save
      get :decline, {id: @job_offer.id}
      response.should redirect_to(job_offers_path)
    end     
    it "declines job offers" do
      @job_offer.responsible_user = FactoryGirl.create(:user, email: "test@example.com")
      @job_offer.save
      sign_in deputy
      expect {
        get :decline, {id: @job_offer.id}
      }.to change(JobOffer, :count).by(-1)
      response.should redirect_to(job_offers_path)
    end 
  end

  describe "GET reopen" do
    describe "with valid params" do

      before(:each) do
        sign_in responsible_user
        @job_offer = JobOffer.create! valid_attributes
        @job_offer.update(chair: chair, status: FactoryGirl.create(:job_status, :running), responsible_user: responsible_user)
      end

      it "assigns a new job_offer as @job_offer" do
        get :reopen, {:id => @job_offer}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
        response.should render_template("new")
      end

      it "has same values as the original job offer" do
        get :reopen, {:id => @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        expected_attr = [:description, :title, :time_effort, :compensation, :room_number, :chair_id, :responsible_user_id]        

        reopend_job_offer.attributes.with_indifferent_access.slice(expected_attr).should eql(@job_offer.attributes.with_indifferent_access.slice(expected_attr))
        reopend_job_offer.start_date.should be_nil
        reopend_job_offer.end_date.should be_nil
        reopend_job_offer.assigned_student_id.should be_nil
      end

      it "is pending and old job offer changes to completed" do
        get :reopen, {:id => @job_offer}, valid_session
        reopend_job_offer = assigns(:job_offer)
        JobOffer.find(@job_offer).status.should eql(completed)
      end
    end
  end

  describe "POST create" do

    before(:each) do
      sign_in responsible_user
    end
    
    describe "with valid params" do
      it "creates a new job_offer" do
        expect {
          post :create, {:job_offer => valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
      end

      it "assigns a newly created job_offer as @job_offer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        assigns(:job_offer).should be_a(JobOffer)
        assigns(:job_offer).should be_persisted
      end

      it "redirects to the created job_offer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        response.should redirect_to(JobOffer.last)
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
      it "should not send mail to deputy" do
        job_offer = JobOffer.create! valid_attributes
        #expect
        JobOffersMailer.should_not_receive(:new_job_offer_email).with( job_offer, valid_session )
        # when
        JobOffer.create! valid_attributes
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      @job_offer = JobOffer.create! valid_attributes

      sign_in @job_offer.responsible_user
    end

    describe "with valid params" do
      it "updates the requested job_offer" do
        # Assuming there are no other job_offers in the database, this
        # specifies that the job_offer created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        JobOffer.any_instance.should_receive(:update).with({ "description" => "MyString" })
        put :update, {:id => @job_offer.to_param, :job_offer => { "description" => "MyString" }}, valid_session
      end

      it "assigns the requested job_offer as @job_offer" do
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        assigns(:job_offer).should eq(@job_offer)
      end

      it "redirects to the job_offer" do
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end

      it "only allows the responsible user to update" do
        @job_offer.responsible_user = FactoryGirl.create(:user)
        @job_offer.save
        put :update, {:id => @job_offer.to_param, :job_offer => valid_attributes}, valid_session
        response.should redirect_to(@job_offer)
      end
    end

    describe "with invalid params" do
      it "assigns the job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {:id => @job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should eq(@job_offer)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {:id => @job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @job_offer = JobOffer.create! valid_attributes

      sign_in @job_offer.responsible_user
    end

    it "destroys the requested job_offer" do
      expect {
        delete :destroy, {:id => @job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(-1)
    end

    it "redirects to the job_offers list" do
      delete :destroy, {:id => @job_offer.to_param}, valid_session
      response.should redirect_to(job_offers_url)
    end
  end

end
