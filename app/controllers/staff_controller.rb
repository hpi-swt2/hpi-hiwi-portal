class StaffController < ApplicationController
  include UsersHelper

  skip_before_action :signed_in_user, only: [:new, :create]

  before_action :set_staff, only: [:show, :edit, :update]

  authorize_resource only: [:index]
  load_and_authorize_resource only: [:destroy]

  def index
    @staff_members = Staff.joins(:user).order(:lastname, :firstname).paginate(page: params[:page], per_page: 20)
  end

  def show
  end

  def new
    @employer = Employer.find_by_token(params[:token])
    if @employer.nil?
      redirect_to(root_path, notice: I18n.t("staff.messages.wrong_token"))
    end
    @staff = Staff.new
    @staff.build_user
  end

  def create
    @staff = Staff.new staff_params
    @staff.employer = Employer.find_by_token(employer_params[:token])
    if @staff.save
      sign_in @staff.user
      flash[:success] = "Welcome to HPI Connect!"
      redirect_to root_path
    else
      flash[:error] = @staff.errors.full_messages.join(", ")
      redirect_back fallback_location: staff_index_path
    end
  end

  def destroy
    @staff.destroy
    respond_and_redirect_to staff_index_path, I18n.t('users.messages.successfully_deleted.')
  end

  private

    def set_staff
      @staff = Staff.find params[:id]
    end

    def staff_params
      params.require(:staff).permit(user_attributes: [:firstname, :lastname, :email, :password, :password_confirmation])
    end

    def employer_params
      params.require(:staff).permit(:token)
    end

    def rescue_from_exception(exception)
      if [:destroy].include? exception.action
        respond_and_redirect_to exception.subject, exception.message
      else
        respond_and_redirect_to root_path, exception.message
      end
    end
end
