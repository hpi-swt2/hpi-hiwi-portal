  require 'rails_helper'


describe "Job Offer pages" do

  subject { page }

  let(:staff) { FactoryBot.create(:staff) }

  before(:all) do
    @status_pending = JobStatus.pending
    @status_active = JobStatus.active
    @status_closed = JobStatus.closed
  end

  describe "edit page" do
    let(:job_offer) { FactoryBot.create(:job_offer, status: @status_active) }

    describe "visited by a staff member whose employer has no contact address" do
      before do
        staff.employer.contact.assign_attributes name: nil, street: nil, zip_city: nil
        staff.employer.contact.save(validate: false)
        login staff.user
        visit new_job_offer_path
      end

      it "has a checked checkbox to copy contact address to employer" do
        expect(page).to have_checked_field(I18n.t("job_offers.copy_to_employer_contact"))
      end
    end

    describe "visited by a staff member whose employer has a contact address" do
      before do
        login staff.user
        visit new_job_offer_path
      end

      it "prefills contact fields with employer's contact address" do
        expect(find_field(I18n.t("activerecord.attributes.contact.name")).value).to eq staff.employer.contact.name
        expect(find_field(I18n.t("activerecord.attributes.contact.street")).value).to eq staff.employer.contact.street
        expect(find_field(I18n.t("activerecord.attributes.contact.zip_city")).value).to eq staff.employer.contact.zip_city
        expect(find_field(I18n.t("activerecord.attributes.contact.email")).value).to eq staff.employer.contact.email
        expect(find_field(I18n.t("activerecord.attributes.contact.phone")).value).to eq staff.employer.contact.phone
        expect(find_field(I18n.t("activerecord.attributes.contact.company")).value).to eq staff.employer.name
      end

      it "does not have a checked checkbox to copy contact address to employer" do
        expect(page).to have_field(I18n.t("job_offers.copy_to_employer_contact"))
        expect(page).not_to have_checked_field(I18n.t("job_offers.copy_to_employer_contact"))
      end
    end
  end

  describe "show page" do
    describe "open job offer" do
      let(:job_offer) { FactoryBot.create(:job_offer, status: @status_active) }

      before do
        login staff.user
        visit job_offer_path(job_offer)
      end

      describe "application button and list" do
        let(:student) { FactoryBot.create(:student) }

        describe "as a student" do
          before do
            login student.user
            visit job_offer_path(job_offer)
          end

          it { is_expected.not_to have_link('Edit')}
        end
      end
    end

    describe "running job offer" do
      let(:employer) { FactoryBot.create(:employer) }
      let(:staff) { employer.staff_members.first }
      let(:job_offer) { FactoryBot.create(:job_offer, employer: employer, status: @status_active) }

      let(:student) { FactoryBot.create(:student) }

      describe "as a student" do
        before(:each) do
          login student.user
        end

        it { is_expected.not_to have_button('Apply')}
      end

      describe "as a staff of the job offers employer" do
        let(:staff) { FactoryBot.create(:staff, employer: job_offer.employer) }

        before do
          login staff.user
          visit job_offer_path(job_offer)
        end

        it { is_expected.to have_link I18n.t('job_offers.job_completed') }
        it { is_expected.not_to have_link 'Reopen job offer'}
      end

      describe "as the responsible user" do
        before do
          login job_offer.employer.staff_members[0].user
          visit edit_job_offer_path(job_offer)
        end

        it "shouldn't display a delete button" do
          is_expected.not_to have_link I18n.t("links.destroy")
        end
      end

      describe "as a admin" do
        let(:admin) { FactoryBot.create(:user, :admin) }

        before do
          login admin
          visit job_offer_path(job_offer)
        end

        it { is_expected.to have_link I18n.t('job_offers.job_completed') }
        it { is_expected.not_to have_link 'Reopen job offer'}
      end
    end

    describe "pending job offer" do

      let(:employer) { FactoryBot.create(:employer) }
      let(:staff) { employer.staff_members.first }
      let(:job_offer) { FactoryBot.create(:job_offer, employer: employer, status: @status_pending) }

      let(:student) { FactoryBot.create(:student) }

      before do
        staff.update(employer: employer)
      end

      describe "as a student" do
        before(:each) do
          login student.user
        end

        it "should not be visible in the job offers list" do
          visit job_offers_path
          is_expected.not_to have_content(job_offer.title)
        end

        it "should be redirected to the index page" do
          visit job_offer_path(job_offer)
          expect(current_path).to eq(job_offers_path)
        end
      end

      describe "as a staff of the job offers employer" do
        let(:staff) { FactoryBot.create(:staff, employer: employer) }

        before do
          login staff.user
          visit job_offer_path(job_offer)
        end

        it "should be editable for the responsible user" do
          is_expected.to have_selector 'a:contains("Edit"):not(disabled)'
          is_expected.to have_selector 'a:contains("Delete"):not(disabled)'

          is_expected.to have_content(I18n.t('job_offers.pending'))

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end
      end

      describe "as staff of the employer" do
        before do
          login staff.user
          visit job_offer_path(job_offer)
        end

        it "should be editable for any staff" do
          is_expected.to have_selector 'a:contains("Edit"):not(disabled)'
          is_expected.to have_selector 'a:contains("Delete"):not(disabled)'

          is_expected.to have_content(I18n.t('job_offers.pending'))

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end

        it "is not possible to accept or decline the job offer" do
          #This is now Admin Job
          is_expected.not_to have_link('Accept')
          is_expected.not_to have_link('Decline')
        end
      end

      describe "as admin" do
        let(:admin) { FactoryBot.create(:user, :admin) }

        before do
          login admin
          visit job_offer_path(job_offer)
        end

        it "should be editable for the any staff" do
          is_expected.to have_selector 'a:contains("Edit"):not(disabled)'
          is_expected.to have_selector 'a:contains("Delete"):not(disabled)'

          is_expected.to have_content(I18n.t('job_offers.pending'))

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end

        it "is possible to accept or decline the job offer" do

          is_expected.to have_link('Accept')
          is_expected.to have_link('Decline')
        end
      end
    end

    describe "completed job offer" do
      let(:job_offer) { FactoryBot.create(:job_offer, status: @status_closed) }

      before { visit job_offer_path(job_offer) }

      describe "as admin" do
        let(:admin) { FactoryBot.create(:user, :admin) }

        before do
          login admin
          visit job_offer_path(job_offer)
        end

        it { is_expected.to have_link('Reopen job offer') }

      end
    end

    describe "show jobs in archive" do
      let(:admin) { FactoryBot.create(:user, :admin)}
      let(:staff) { FactoryBot.create(:staff)}
      let(:student) { FactoryBot.create(:student)}
      before do
        FactoryBot.create(:job_offer, title: "archive job", status: @status_closed)
      end

      it "shows job offer details link for admin" do
        login admin
        visit archive_job_offers_path
        expect(page).to have_link("archive job")
      end

      it "doesn't show job offer details link for students" do
        login student.user
        visit archive_job_offers_path
        expect(page).not_to have_link("archive job")
      end

      it "doesn't show job offer details link for staff" do
        login staff.user
        visit archive_job_offers_path
        expect(page).not_to have_link("archive job")
      end
    end
  end

  describe "index page" do

    before :each do
      @job_offer_with_bachelor = FactoryBot.create(:job_offer, graduation_id: Student::GRADUATIONS.index('bachelor'), state_id: JobOffer::STATES.index("BE"), status: JobStatus.active)
      @job_offer_with_abitur = FactoryBot.create(:job_offer, graduation_id: Student::GRADUATIONS.index('abitur'), state_id: JobOffer::STATES.index("BE"), status: JobStatus.active)
      visit job_offers_path
    end

    it "also displays job_offers with lower graduation" do
      find('#graduation').find(:xpath, 'option[3]').select_option
      find('#find_jobs_button').click
      expect(page).to have_content @job_offer_with_bachelor.title
      expect(page).to have_content @job_offer_with_abitur.title
    end

    it "does not display job_offer with higher graduation" do
      find('#graduation').find(:xpath, 'option[2]').select_option
      find('#find_jobs_button').click
      expect(page).to have_content @job_offer_with_abitur.title
      expect(page).not_to have_content @job_offer_with_bachelor.title
    end
  end
end
