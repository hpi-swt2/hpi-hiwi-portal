require 'rails_helper'

describe HomeController do

  before(:all) do
    FactoryBot.create(:job_status, :pending)
    FactoryBot.create(:job_status, :active)
    FactoryBot.create(:job_status, :closed)
  end

  before(:each) do
    login FactoryBot.create(:student).user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_successful
    end

    it "assigns latest 5 job_offers" do
      6.times { |i| FactoryBot.create(:job_offer, title:"Testjob#{i+1}", status: JobStatus.active) }
      get 'index'
      expect(assigns(:job_offers).length).to eq(5)
      expect(assigns(:job_offers)).not_to include(JobOffer.find_by_title("Testjob1"))
    end

    it "does not assign pending JobOffers" do
      5.times { |i| FactoryBot.create(:job_offer, title:"Testjob#{i+1}", status: JobStatus.active) }
      pending_job = FactoryBot.create(:job_offer, title: "Pending Job", status: JobStatus.pending)
      get 'index'
      expect(assigns(:job_offers)).not_to include(pending_job)
    end

    it "assigns latest 5 employers" do
      6.times { |i| FactoryBot.create(:employer, name:"TestEmployer#{i+1}") }
      get 'index'
      expect(assigns(:employers).length).to eq(5)
      expect(assigns(:employers)).not_to include(JobOffer.find_by_title("TestEmployer1"))
    end

    it "does not assign not activated employers" do
      3.times { |i| FactoryBot.create(:employer, name:"TestEmployer#{i+1}") }
      not_activated_employer = FactoryBot.create(:employer, activated: false, name:"NotActiveEmployer")
      get 'index'
      expect(assigns(:employers)).not_to include not_activated_employer
    end

  end

  describe "GET 'imprint'" do
    it "returns http success" do
      get 'imprint'
      expect(response).to be_successful
    end
  end

end
