# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description               :text
#  title                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  start_date                :date
#  end_date                  :date
#  time_effort               :float
#  compensation              :float
#  employer_id               :integer
#  status_id                 :integer
#  flexible_start_date       :boolean          default(FALSE)
#  category_id               :integer          default(0), not null
#  state_id                  :integer          default(3), not null
#  graduation_id             :integer          default(2), not null
#  prolong_requested         :boolean          default(FALSE)
#  prolonged                 :boolean          default(FALSE)
#  prolonged_at              :datetime
#  release_date              :date
#  offer_as_pdf_file_name    :string(255)
#  offer_as_pdf_content_type :string(255)
#  offer_as_pdf_file_size    :integer
#  offer_as_pdf_updated_at   :datetime
#  student_group_id          :integer          default(0), not null
#

require "spec_helper"

describe JobOffersController do
  describe "routing" do

    it "routes to #index" do
      get("/job_offers").should route_to("job_offers#index")
    end

    it "routes to #new" do
      get("/job_offers/new").should route_to("job_offers#new")
    end

    it "routes to #show" do
      get("/job_offers/1").should route_to("job_offers#show", id: "1")
    end

    it "routes to #edit" do
      get("/job_offers/1/edit").should route_to("job_offers#edit", id: "1")
    end

    it "routes to #create" do
      post("/job_offers").should route_to("job_offers#create")
    end

    it "routes to #update" do
      put("/job_offers/1").should route_to("job_offers#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/job_offers/1").should route_to("job_offers#destroy", id: "1")
    end

  end
end
