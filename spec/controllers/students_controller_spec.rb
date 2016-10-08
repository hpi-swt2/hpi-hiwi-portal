# == Schema Information
#
# Table name: students
#
#  id                        :integer          not null, primary key
#  semester                  :integer
#  academic_program          :string(255)
#  education                 :text
#  additional_information    :text
#  birthday                  :date
#  homepage                  :string(255)
#  github                    :string(255)
#  facebook                  :string(255)
#  xing                      :string(255)
#  linkedin                  :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  employment_status_id      :integer          default(0), not null
#  frequency                 :integer          default(1), not null
#  academic_program_id       :integer          default(0), not null
#  graduation_id             :integer          default(0), not null
#  visibility_id             :integer          default(0), not null
#  dschool_status_id         :integer          default(0), not null
#  group_id                  :integer          default(0), not null
#  hidden_title              :string(255)
#  hidden_birth_name         :string(255)
#  hidden_graduation_id      :integer
#  hidden_graduation_year    :integer
#  hidden_private_email      :string(255)
#  hidden_alumni_email       :string(255)
#  hidden_additional_email   :string(255)
#  hidden_last_employer      :string(255)
#  hidden_current_position   :string(255)
#  hidden_street             :string(255)
#  hidden_location           :string(255)
#  hidden_postcode           :string(255)
#  hidden_country            :string(255)
#  hidden_phone_number       :string(255)
#  hidden_comment            :string(255)
#  hidden_agreed_alumni_work :string(255)
#

require 'spec_helper'

describe StudentsController do

  let(:valid_attributes) { { "semester" => "3", "graduation_id" => Student::GRADUATIONS.index("bachelor"), "academic_program_id" => Student::ACADEMIC_PROGRAMS.index("master") } }

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  let(:staff) { FactoryGirl.create(:staff) }
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  let(:valid_session) { {} }


  describe "GET index" do
    it "assigns all students as @students" do
      login FactoryGirl.create(:user, :admin)

      student = FactoryGirl.create(:student)
      get :index, {}, valid_session
      assigns(:students).should eq(Student.all.sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: 1, per_page: 5))
    end
  end

  describe "GET show" do
    it "assigns the requested user as @student" do
      student = FactoryGirl.create(:student)
      get :show, { id: student.to_param }, valid_session
      assigns(:student).should eq(student)
    end
  end

  describe "GET edit" do
    it "assigns the requested student as @student" do
      student = FactoryGirl.create(:student)
      get :edit, {id: student.to_param}, valid_session
      assigns(:student).should eq(student)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested student" do
        student = FactoryGirl.create(:student)
        Student.any_instance.should_receive(:update).with({ "semester" => "5" })
        put :update, {id: student.to_param, student: { semester: 5 }}, valid_session
      end

      it "assigns the requested student as @student" do
        student = FactoryGirl.create(:student)
        put :update, {id: student.to_param, student: valid_attributes}, valid_session
        assigns(:student).should eq(student)
      end

      it "redirects to the student" do
        student = FactoryGirl.create(:student)
        put :update, {id: student.to_param, student: valid_attributes}, valid_session
        response.should redirect_to(student_path(student))
      end
    end

    describe "with invalid params" do
      it "assigns the student as @student" do
        student = FactoryGirl.create(:student)
        Student.any_instance.stub(:save).and_return(false)
        put :update, {id: student.to_param, student: { semester: -1 }}, valid_session
        assigns(:student).should eq(student)
      end

      it "re-renders the 'edit' template" do
        student = FactoryGirl.create(:student)
        Student.any_instance.stub(:save).and_return(false)
        put :update, {id: student.to_param, student: { semester: -1 }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "PATCH update" do
    before(:each) do
      @student = FactoryGirl.create(:student)
    end

    it "handles nil strings and unrealistic values" do

      params = {
        "additional_information" => nil,
        "birthday" => nil,
        "facebook" => nil,
        "github" => nil,
        "homepage" => nil,
        "linkedin" => nil,
        "photo" => nil,
        "semester" => 100,
        "employer_status_id" => "1",
        "xing" => nil
      }

      patch :update, { id: @student.id, student: params}
      response.should render_template("edit")
    end

    it "saves uploaded images" do
      test_file = ActionDispatch::Http::UploadedFile.new({
        filename: 'test_picture.jpg',
        type: 'image/jpeg',
        tempfile: fixture_file_upload('/images/test_picture.jpg')
      })

      patch :update, { id: @student.id, student: { user_attributes: { "photo" => test_file } } }
      response.should redirect_to(student_path(@student))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student and redirects to students page" do
      student = FactoryGirl.create(:student)
      login FactoryGirl.create(:user, :admin)
      expect {
        delete :destroy, {id: student.to_param}, valid_session
      }.to change(Student, :count).by(-1)
      response.should redirect_to students_path
    end

    it "allows student to delete himself" do
      student = FactoryGirl.create(:student)
      login student.user
      expect {
        delete :destroy, {id: student.to_param}, valid_session
      }.to change(Student, :count).by(-1)
      response.should redirect_to students_path
    end

    it "doesn't allow student to delete other students" do
      student1 = FactoryGirl.create(:student)
      student2 = FactoryGirl.create(:student)
      login student1.user
      expect {
        delete :destroy, {id: student2.to_param}, valid_session
      }.to change(Student, :count).by(0)
      response.should redirect_to student_path(student2)
    end
  end

  describe "GET matching" do
    it "finds all users with the requested programming language, and language" do
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
      @language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)

      @student1 = FactoryGirl.create(:student, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1])
      @student2 = FactoryGirl.create(:student, programming_languages: [@programming_language_1], languages: [@language_1, @language_2])
      @student3 = FactoryGirl.create(:student, programming_languages: [@programming_language_2], languages: [@language_1])
      @student4 = FactoryGirl.create(:student, programming_languages: [@programming_language_2], languages: [@language_2])
      @student5 = FactoryGirl.create(:student, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1, @language_2])

      login FactoryGirl.create(:user, :admin)
      old_path = current_path
      get :index, ({ language_ids: [@language_1.id], programming_language_ids: [@programming_language_1.id]}), valid_session
      assert current_path.should == old_path
      assigns(:students).should eq([@student1, @student2, @student5].sort_by{ |x| [x.lastname, x.firstname] }.paginate page: 1, per_page: 5)
    end
  end

  describe "GET export_alumni" do

    it "should send a CSV file with all alumni to the admin" do
      require 'csv'
      registered = FactoryGirl.create(:student)
      registered.user.update_attributes(alumni_email: 'registered.alumni')
      current_cv_job = FactoryGirl.create(:cv_job, current: true)
      registered.cv_jobs = [current_cv_job]
      pending = FactoryGirl.create(:alumni)

      login FactoryGirl.create(:user, :admin)
      get :export_alumni
      csv = CSV.parse(response.body)
      csv_array = csv.to_a
      expect(csv[0]).to eq(%w{registered? lastname firstname alumni_email email graduation current_enterprise(s) current_position(s)})
      expect(csv[1]).to eq(["yes", registered.lastname, registered.firstname, registered.alumni_email, registered.email, "General Qualification for University Entrance", "SAP AG", "Ruby on Rails developer"])
      expect(csv[2]).to eq(["The following alumni are not registered, yet", "", "", ""])
      expect(csv[3]).to eq(["no", pending.lastname, pending.firstname, pending.alumni_email, pending.email])
    end

    it "should not send a CSV to a student" do
      login FactoryGirl.create(:student).user
      get :export_alumni
      response.should redirect_to(root_path)
      flash[:notice].should eql("You are not authorized to access this page.")
    end

    it "should not send a CSV to a staff member" do
      login FactoryGirl.create(:staff).user
      get :export_alumni
      response.should redirect_to(root_path)
      flash[:notice].should eql("You are not authorized to access this page.")
    end
  end

  describe "GET activate" do
    describe "as an admin" do

      before :each do
        login FactoryGirl.create(:user, :admin)
        @student = FactoryGirl.create(:student)
        @student.user.update_column :activated, false
      end

      it "should be accessible" do
        get :activate, ({ id: @student.id })
        response.should redirect_to(@student)
      end

      it "should activate the student" do
        get :activate, ({ id: @student.id })
        @student.reload
        assert @student.user.activated
      end
    end

    describe "as a student" do

      before :each do
        @student = FactoryGirl.create(:student)
        login @student.user
      end

      it "should be accessible for the own profile" do
        get :activate, ({ id: @student.id, student: { username: 'max.mustermann' }})
        response.should_not redirect_to(root_path)
      end

      it "should not be accessible for other profiles" do
        get :activate, ({ id: FactoryGirl.create(:student).id })
        response.should redirect_to(root_path)
        flash[:notice].should eql("You are not authorized to access this page.")
      end
    end

    it "should not be accessible for staff members" do
      staff = FactoryGirl.create(:staff)
      login staff.user
      get :activate, ({ id: FactoryGirl.create(:student).id })
      response.should redirect_to(root_path)
      flash[:notice].should eql("You are not authorized to access this page.")
    end
  end

  describe "PUT update with programming languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:student, valid_attributes)
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
    end

    it "updates the requested student with an existing programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      @student.programming_languages_users.size.should eq(1)
      ProgrammingLanguagesUser.any_instance.should_receive(:update_attributes).with({ skill: "2" })
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, programming_language_skills: { @programming_language_1.id.to_s => "2" } }, valid_session
    end

    it "updates the requested student with a new programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, programming_language_skills: { @programming_language_1.id.to_s => "4", @programming_language_2.id.to_s => "2" } }, valid_session
      @student.reload
      @student.programming_languages_users.size.should eq(2)
      @student.programming_languages.first.should eq(@programming_language_1)
      @student.programming_languages.last.should eq(@programming_language_2)
    end

    it "updates the requested student with a removed programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4'), FactoryGirl.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, programming_language_skills: { @programming_language_1.id.to_s => "2" } }, valid_session
      @student.reload
      @student.programming_languages_users.size.should eq(1)
      @student.programming_languages.first.should eq(@programming_language_1)
    end
  end

  describe "PUT update with languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:student, valid_attributes)
      @language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)
    end

    it "updates the requested student with an existing language" do
      @student.assign_attributes(languages_users: [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      @student.languages_users.size.should eq(1)
      LanguagesUser.any_instance.should_receive(:update_attributes).with({ skill: "2" })
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "2" } }, valid_session
    end

    it "updates the requested student with a new language" do
      @student.assign_attributes(languages_users: [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "4", @language_2.id.to_s => "2" } }, valid_session
      @student.reload
      @student.languages_users.size.should eq(2)
      @student.languages.first.should eq(@language_1)
      @student.languages.last.should eq(@language_2)
    end

    it "updates the requested student with a removed language" do
      @student.assign_attributes(languages_users: [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4'), FactoryGirl.create(:languages_user, language_id: @language_2.id, skill: '2')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "2" } }, valid_session
      @student.reload
      @student.languages_users.size.should eq(1)
      @student.languages.first.should eq(@language_1)
    end
  end
end
