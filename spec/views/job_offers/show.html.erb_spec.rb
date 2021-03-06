require 'rails_helper'

describe "job_offers/show" do
  before(:each) do
    @employer = FactoryBot.create(:employer)
    @job_offer = assign(:job_offer, FactoryBot.create(:job_offer,
      description: "Description",
      title: "Title",
      employer: @employer,
      start_date: Date.current + 10,
      end_date: Date.current + 20,
      status: FactoryBot.create(:job_status, name: "active")
    ))
    allow(view).to receive(:can?) { false }
    allow(view).to receive(:current_user) { FactoryBot.create(:user) }
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Title/)
  end

  it "renders the default compensation text if applicable" do
    @job_offer.compensation = 10.0
    @job_offer.save

    render

    expect(rendered).to match(I18n.t('job_offers.default_compensation'))
  end

  it "renders the actual compensation if its not the default one" do
    @job_offer.compensation = 11.0
    @job_offer.save

    render

    expect(rendered).to match(@job_offer.compensation.to_s + " " + I18n.t('job_offers.compensation_description'))
  end
end
