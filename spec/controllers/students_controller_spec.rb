require 'spec_helper'

describe StudentsController do

  let(:valid_attributes) { { "semester" => "3", "education" => "Master", "academic_program" => "Volkswirtschaftslehre" } }
  
  before(:each) do
    login FactoryGirl.create(:student).user
  end

  # Programming Languages with a mapping to skill integers
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  let(:valid_session) { {} }

  let(:staff) { FactoryGirl.create(:staff) }

  describe "GET index" do
    it "assigns all user as @users" do
      login staff.user

      student = FactoryGirl.create(:student)
      get :index, {}, valid_session
      assigns(:students).should eq(Students.paginate(:page => 1, :per_page => 5))
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      student = FactoryGirl.create(:student)
      get :show, { id: student.to_param }, valid_session
      assigns(:student).should eq(student)
    end
  end

  describe "GET edit" do
    it "assigns the requested student as @user" do
      student = FactoryGirl.create(:student)
      get :edit, {id: student.to_param}, valid_session
      assigns(:student).should eq(student)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        student = FactoryGirl.create(:student)
        student.any_instance.should_receive(:update).with({ semester: 5 })
        put :update, {id: student.to_param, student: { semester: 5 }}, valid_session
      end

      it "assigns the requested student as @user" do
        student = FactoryGirl.create(:student)
        put :update, {id: student.to_param, student: valid_attributes}, valid_session
        assigns(:user).should eq(student)
      end

      it "redirects to the student" do
        student = FactoryGirl.create(:student)
        put :update, {id: student.to_param, student: valid_attributes}, valid_session
        response.should redirect_to(student_path(student))
      end
    end

    describe "with invalid params" do
      it "assigns the student as @user" do
        student = FactoryGirl.create(:student)
        Student.any_instance.stub(:save).and_return(false)
        put :update, {id: student.to_param, user: { "firstname" => "invalid value" }}, valid_session
        assigns(:user).should eq(student)
      end

      it "re-renders the 'edit' template" do
        student = FactoryGirl.create(:student)
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {id: student.to_param, user: { "firstname" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "PATCH update" do
    before do
      @student = FactoryGirl.create(:student)
    end

    it "handles nil strings" do

      params = {
        "academic_program" => nil,
        "additional_information" => nil,
        "birthday" => nil,
        "education" => nil,
        "email" => "alexander.zeier@accenture.com",
        "facebook" => nil,
        "firstname" => "Alexander",
        "github" => nil,
        "homepage" => nil,
        "lastname" => "Zeier",
        "linkedin" => nil,
        "photo" => nil,
        "semester" => nil,
        "user_status_id" => "1",
        "xing" => nil
      }

      patch :update, { id: @student.id, user: params}

      response.should render_template("edit")
    end

    it "saves uploaded images" do
      test_file = ActionDispatch::Http::UploadedFile.new({
        :filename => 'test_picture.jpg',
        :type => 'image/jpeg',
        :tempfile => fixture_file_upload('/images/test_picture.jpg')
      })

      patch :update, { id: @student.id, user: { "photo" => test_file } }
      response.should redirect_to(student_path(@student))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student" do
      student = FactoryGirl.create(:student)
      login FactoryGirl.create(:user, :admin)
      expect {
        delete :destroy, {id: student.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the students profile if access is denied" do
      student = FactoryGirl.create(:student)
      expect {
        delete :destroy, {id: student.to_param}, valid_session
      }.to change(User, :count).by(0)
      response.should redirect_to student_path(student)
    end

    it "redirects to the students list" do
      student = FactoryGirl.create(:student)
      login FactoryGirl.create(:user, :admin)
      delete :destroy, {id: student.to_param}, valid_session
      response.should redirect_to(students_path)
    end
  end

  describe "GET matching" do
    it "finds all users with the requested programming language, and language" do
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
      @language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)

      @user1 = FactoryGirl.create(:user, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1])
      @user2 = FactoryGirl.create(:user, programming_languages: [@programming_language_1], languages: [@language_1, @language_2])
      FactoryGirl.create(:user, programming_languages: [@programming_language_2], languages: [@language_1])
      FactoryGirl.create(:user, programming_languages: [@programming_language_2], languages: [@language_2])
      @user3 =FactoryGirl.create(:user, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1, @language_2])

      login FactoryGirl.create(:student)
      old_path = current_path
      get :matching, ({:language_ids => [@language_1.id], :programming_language_ids => [@programming_language_1.id]}), valid_session
      assert current_path.should == old_path
      assigns(:users).should eq([@user1,@user2,@user3])
    end
  end

  describe "PUT update with programming languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:student, valid_attributes)
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
    end

    it "updates the requested student with an existing programming language" do
      @student.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      @student.programming_languages_users.size.should eq(1)
      ProgrammingLanguagesUser.any_instance.should_receive(:update_attributes).with({ :skill => "2" })
      put :update, {id: @student.to_param, user: { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "2" }}, valid_session
    end

    it "updates the requested student with a new programming language" do
      @student.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      put :update, {id: @student.to_param, user: { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "4", @programming_language_2.id.to_s => "2" }}, valid_session
      @student.reload
      @student.programming_languages_users.size.should eq(2)
      @student.programming_languages.first.should eq(@programming_language_1)
      @student.programming_languages.last.should eq(@programming_language_2)
    end

    it "updates the requested student with a removed programming language" do
      @student.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4'), FactoryGirl.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])
      put :update, {id: @student.to_param, user: { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "2" }}, valid_session
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
      @student.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      @student.languages_users.size.should eq(1)
      LanguagesUser.any_instance.should_receive(:update_attributes).with({ :skill => "2" })
      put :update, {id: @student.to_param, user: { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "2" }}, valid_session
    end

    it "updates the requested student with a new language" do
      @student.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      put :update, {id: @student.to_param, user: { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "4", @language_2.id.to_s => "2" }}, valid_session
      @student.reload
      @student.languages_users.size.should eq(2)
      @student.languages.first.should eq(@language_1)
      @student.languages.last.should eq(@language_2)
    end

    it "updates the requested student with a removed language" do
      @student.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4'), FactoryGirl.create(:languages_user, language_id: @language_2.id, skill: '2')])
      put :update, {id: @student.to_param, user: { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "2" }}, valid_session
      @student.reload
      @student.languages_users.size.should eq(1)
      @student.languages.first.should eq(@language_1)
    end
  end
end