require 'spec_helper'


describe "Job Offer pages" do

  subject { page }

  let(:research_assistant_role) { FactoryGirl.create(:role, name: 'Research Assistant', level: 2) }
  before(:each) do
    @status_pending = FactoryGirl.create(:job_status, :pending)
    @status_open = FactoryGirl.create(:job_status, :open)
    @status_running = FactoryGirl.create(:job_status, :running)
    @status_completed = FactoryGirl.create(:job_status, :completed)
  end
  
  describe "show page" do
    describe "open job offer" do
      let(:job_offer) { FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user), status: @status_open) }

      before { visit job_offer_path(job_offer) }

      describe "application button and list" do
        let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
        let(:student) { FactoryGirl.create(:user, role: student_role) }

        describe "without being signed in" do
          it { should_not have_button('Apply') }
          it { should_not have_selector('h4', text: 'Applications') }
        end

        describe "as a student" do
          before do 
            login_as(student, :scope => :user)
            visit job_offer_path(job_offer)
          end

          it { should have_button('Apply') }
          it { should_not have_selector('h4', text: 'Applications') }

          describe "and having applied already" do
            before do 
              FactoryGirl.create(:application, user: student, job_offer: job_offer)
              login_as(student, :scope => :user)
              visit job_offer_path(job_offer)
            end

            it { should_not have_button('Apply') }
            it { should_not have_selector('h4', text: 'Applications') }
            it { should have_selector('div.panel', text: I18n.t('job_offers.already_applied')) }
          end
        end

        describe "as a research assistant of the job offers chair" do
          let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: job_offer.chair) }

          before do
            @application = FactoryGirl.create(:application, job_offer: job_offer)
            login_as(research_assistant, :scope => :user)
            visit job_offer_path(job_offer)
          end

          it { should_not have_button('Apply') }
          it { should have_selector('h4', text: 'Applications') }

          it { should have_link('Accept') }
          it { should have_link('Decline') }

          it { should have_selector('td[href="' + student_path(id: @application.user.id) + '"]') }
        end
      end
    end

    describe "running job offer" do
      let(:deputy) { FactoryGirl.create(:user, role: research_assistant_role)}
      let(:chair) { FactoryGirl.create(:chair, deputy: deputy ) }
      let(:job_offer) { FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user), chair: chair, status: @status_running) }
     
      let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
      let(:student) { FactoryGirl.create(:user, role: student_role) }

      describe "as a student" do
        before(:each) do
          login_as(student, :scope => :user)          
        end 

        it { should_not have_button('Apply')}
      end

      describe "as a research assistant of the job offers chair" do
        let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: job_offer.chair) }

        before do
          login_as(research_assistant, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it { should have_link 'Job completed' }
        it { should have_link 'reopen Job Offer'} 
      end
    end

    describe "pending job offer" do

      let(:deputy) { FactoryGirl.create(:user, role: research_assistant_role)}
      let(:chair) { FactoryGirl.create(:chair, deputy: deputy ) }
      let(:job_offer) { FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user), chair: chair) }
     
      let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
      let(:student) { FactoryGirl.create(:user, role: student_role) }

      before do
        deputy.update(:chair => chair)
      end
      
      describe "as a student" do
        before(:each) do
          login_as(student, :scope => :user)          
        end 

        it "should not be visible in the job offers list" do
          visit job_offers_path
          should_not have_content(job_offer.title)
        end

        it "should be redirected to the index page" do
          visit job_offer_path(job_offer)
          expect(current_path).to eq(job_offers_path)
        end
      end

      describe "as a research assistant of the job offers chair" do
        let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: chair) }

        before do
          job_offer.update(responsible_user: research_assistant)
          login_as(research_assistant, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it "should be editable for the responsible user" do
          should have_selector 'a:contains("Edit"):not(disabled)'
          should have_selector 'a:contains("Delete"):not(disabled)'

          should have_content('pending')

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end
      end

      describe "as the deputy of the chair" do 
        before do          
          login_as(deputy, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it "should be editable for the deputy" do
          should have_selector 'a:contains("Edit"):not(disabled)'
          should have_selector 'a:contains("Delete"):not(disabled)'

          should have_content('pending')

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end

        it "is possible to accept or decline the job offer" do
          
          should have_link('Accept')
          should have_link('Decline')
        end
      end
    end
  
    describe "completed job offer" do
      let(:job_offer) { FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user), status: @status_completed) }

      before { visit job_offer_path(job_offer) }
    
      describe "as a research assistant of the job offers chair" do
        let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: job_offer.chair) }

        before do
          login_as(research_assistant, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it { should have_link('reopen Job Offer') }

      end      
    end
  end
end