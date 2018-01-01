require "rails_helper"

describe StudentsMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @student = FactoryGirl.create(:student)
    ActionMailer::Base.deliveries = []
  end

  describe "new student" do

    before(:each) do
      @email = StudentsMailer.new_student_email(@student).deliver_now
    end

    it "should include the link to the student" do
      expect(@email).to have_body_text(url_for(controller:"students", action: "show", id: @student.id, only_path: false))
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should be send to the administration" do
      expect(@email.to).to eq([Configurable.mailToAdministration])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end
  end

  describe "newsletter" do

    before(:each) do
      3.times do
        FactoryGirl.create(:job_offer, description: "<p> Description </p>")
      end
      @newsletter_order = FactoryGirl.create(:newsletter_order, student: @student)
      @email = StudentsMailer.newsletter(@student, JobOffer.all, @newsletter_order).deliver_now
    end

    it "should send an email" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "should be send to student" do
      expect(@email.to).to eq([@student.email])
    end

    it "should be send from 'noreply-connect@hpi.de'" do
      expect(@email.from).to eq(['noreply-connect@hpi.de'])
    end

    it "should include link to job_offers" do
      for i in 0..2 do
        expect(@email).to have_body_text(url_for(controller:"job_offers", action: "show", id: JobOffer.all[i], only_path: false))
      end
    end

    it "should include link to unsubcribe" do
      expect(@email).to have_body_text(url_for(controller: "newsletter_orders", action: "destroy", id: @newsletter_order.id, only_path: false))
    end

    it "should not include HTML Tags" do
      expect(@email).not_to have_body_text("<p> Description </p>")
      expect(@email).to have_body_text("Description")
    end
  end
end
