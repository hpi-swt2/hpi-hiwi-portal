# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  employment_status_id   :integer          default(0), not null
#  frequency              :integer          default(1), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#  visibility_id          :integer          default(0), not null
#  dschool_status_id      :integer          default(0), not null
#  group_id               :integer          default(0), not null
#

require "spec_helper"

describe StudentsController do
  describe "routing" do

    it "routes to #index" do
      get("/students").should route_to("students#index")
    end

    it "routes to #new" do
      get("/students/new").should route_to("students#new")
    end

    it "routes to #show" do
      get("/students/1").should route_to("students#show", id: "1")
    end

    it "routes to #edit" do
      get("/students/1/edit").should route_to("students#edit", id: "1")
    end

    it "routes to #create" do
      post("/students").should route_to("students#create")
    end

    it "routes to #update" do
      put("/students/1").should route_to("students#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/students/1").should route_to("students#destroy", id: "1")
    end

  end
end
