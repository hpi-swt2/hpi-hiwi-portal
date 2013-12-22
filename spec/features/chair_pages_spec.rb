require 'spec_helper'

describe "the chair page" do

  subject { page }

  let(:chair) { FactoryGirl.create(:chair, name:"EPIC") }
  let(:user) { FactoryGirl.create(:user) }
  let(:deputy) { chair.deputy }

  before do
    @running = FactoryGirl.create(:job_status, name: 'running')
    @open = FactoryGirl.create(:job_status, name: 'open')

    @job_offer_open = FactoryGirl.create(:job_offer, chair: chair, status: FactoryGirl.create(:job_status, name: 'open'))
    @job_offer_running = FactoryGirl.create(:job_offer, chair: chair, status: FactoryGirl.create(:job_status, name: 'running'))

    visit chair_path(chair)
  end

  describe "should show the basic information of the chair" do
    it { should have_content(chair.name) }
    it { should have_content(chair.description) }
    it { should have_content(chair.head_of_chair) }
    it { should have_content(chair.deputy.email) }
  end

  describe "being the deputy or an admin" do
      before do
        login_as(deputy, :scope => :user)
      end

      it { should have_link 'Edit' }
    end

  describe "shows job offers for the chair" do

    it { should have_content('Open') }
    it { should have_content('Running') }

    it { should have_content(@job_offer_open.title) }
    it { should have_content(@job_offer_running.title) }

    it { should have_content(@job_offer_open.start_date) }
    it { should have_content(@job_offer_running.start_date) }

    it { should have_content(@job_offer_open.chair.name) }
    it { should have_content(@job_offer_running.chair.name) }

  end

 end
