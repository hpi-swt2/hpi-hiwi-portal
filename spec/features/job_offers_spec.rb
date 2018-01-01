require 'rails_helper'

describe "the job-offers page" do

  before(:each) do
    @active = JobStatus.active
    @student1 = FactoryGirl.create(:student)
    login @student1.user
    @epic = FactoryGirl.create(:employer, name:"EPIC", booked_package_id: 2)
    @active = JobStatus.active
    @pending = JobStatus.pending
    @test_employer = FactoryGirl.create(:employer)
    @staff = FactoryGirl.create(:staff)
    @job_offer_1 = FactoryGirl.create(:job_offer, title: "TestJob1", employer: @test_employer, status: @active)
    @job_offer_2 = FactoryGirl.create(:job_offer, title: "TestJob2", employer: @epic, status: @active)
    @job_offer_3 = FactoryGirl.create(:job_offer, title: "TestJob3", state_id: 3, category_id: JobOffer::CATEGORIES.index("graduate_job"), employer: @epic, status: @active)
    @job_offer_4 = FactoryGirl.create(:job_offer, title: "Pending Job", category_id: JobOffer::CATEGORIES.index("graduate_job"), employer: @epic, status: @pending)
  end

  it "should include all jobs currently available" do
    visit job_offers_path
    expect(page).to have_content(@job_offer_1.title)
    expect(page).to have_content(@job_offer_2.title)
    expect(page).to have_content(@job_offer_3.title)
    expect(page).not_to have_content(@job_offer_4.title)
  end

  it "should sort the jobs by creation date" do
    visit job_offers_path
    # using regex for order of elements
    expect(page).to have_content(Regexp.new("""
      #{@job_offer_3.title}.*#{@job_offer_2.title}.*#{@job_offer_1.title}
    """.strip))
  end

  it "should show prolonged Date if available" do
    JobOffer.delete_all
    job_offer = FactoryGirl.create(:job_offer, status: JobStatus.active, prolonged: true, prolonged_at: Date.current,
                       release_date: Date.current-1)
    visit job_offers_path
    expect(page).to have_content(job_offer.prolonged_at.to_date)
  end


  it "should not show check box to search for pending to students" do
    visit job_offers_path
    expect(page).not_to have_content("Pending jobs")
  end

  it "should be possible for admins to search for pending jobs" do
    login FactoryGirl.create(:user, :admin)
    visit job_offers_path
    find(:css, "#pending").set(true)
    click_on "Go!"
    expect(page).to_not have_content(@job_offer_1.title)
    expect(page).to_not have_content(@job_offer_2.title)
    expect(page).to_not have_content(@job_offer_3.title)
    expect(page).to have_content(@job_offer_4.title)
  end
end

describe "a job offer entry" do

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  before(:each) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)

    @student1 = FactoryGirl.create(:student)
    login @student1.user

    @employer = FactoryGirl.create(:employer)
    @staff = FactoryGirl.create(:staff)
    @job_offer = FactoryGirl.create(:job_offer,
      title: "TestJob",
      employer: @employer,
      status: JobStatus.active
    )

    visit job_offers_path
  end

  it "should have a title and the professorship" do
    expect(page).to have_content(@job_offer.title)
    expect(page).to have_content(@employer.name)
  end

  it "should link to its detailed page" do
    find_link("TestJob").click
    # we expect to be on the detailed page
    expect(current_path).to eq(job_offer_path(@job_offer))
  end
end

describe "job_offers_history" do

  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :active)
    FactoryGirl.create(:job_status, :closed)
  end

  it "should have a job-offers-history" do
    student1 = FactoryGirl.create(:student)
    login student1.user
    closed_job_offer = FactoryGirl.create(:job_offer,
      title: "Closed Job Touch Floor",
      status: JobStatus.closed
    )
    visit job_offers_path
    expect(find("#top-links")).to have_link "Archive"
    click_on "Archive"

    expect(current_path).to eq(archive_job_offers_path)

    expect(page).to have_css "ul.list-group li"
    expect(page).to have_css "#search"
    expect(page).to have_css "#filtering"
    expect(page).to have_css "#search"
    find_button("Go").visible?
    expect(first("ul.list-group li")).to have_content closed_job_offer.title
  end

  describe "Show Archive Job Offers" do
    before :each do
      staff1 = FactoryGirl.create(:staff)
      staff2 = FactoryGirl.create(:staff)
      @closed_job_offer_for_staff_1 = FactoryGirl.create(:job_offer, status: JobStatus.closed, employer: staff1.employer)
      @closed_job_offer_for_staff_2 = FactoryGirl.create(:job_offer, status: JobStatus.closed, employer: staff2.employer)
      login staff1.user
      visit archive_job_offers_path
    end

    it "should be possible to show own archive jobs" do
      expect(page).to have_link @closed_job_offer_for_staff_1.title
    end

    it "should not be possible to show other archive jobs" do
      expect(page).not_to have_link @closed_job_offer_for_staff_2.title
    end

    it "should be possible to see all jobs for the admin" do
      login FactoryGirl.create(:user, :admin)
      visit archive_job_offers_path
      expect(page).to have_link @closed_job_offer_for_staff_1.title
      expect(page).to have_link @closed_job_offer_for_staff_2.title
    end
  end
end
