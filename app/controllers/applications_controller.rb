class ApplicationsController < ApplicationController
  include UsersHelper

  before_filter :check_attachment_is_valid, only: [:create]

  def create
    @job_offer = JobOffer.find application_params[:job_offer_id]

    authorize! :create, Application
    if @job_offer.active?
      if Application.create_and_notify @job_offer, current_user.manifestation, params
        flash[:success] = t("applications.applied_successfully")
      else
        flash[:error] = t("applications.error")
      end
    else
      flash[:error] = t("applications.error_not_found")
    end
    redirect_to @job_offer
  end

  def destroy
    @application = Application.find params[:id]
    if @application.destroy
      respond_and_redirect_to @application.job_offer, t("applications.deleted_successfully")
    else
      render_errors_and_action @application.job_offer
    end
  end

  def accept
    @application = Application.find params[:id]
    @job_offer = @application.job_offer

    authorize! :accept, @application

    if @job_offer.accept_application(@application)
      respond_and_redirect_to @job_offer, 'Application was successfully accepted.'
    else
      render_errors_and_action @job_offer
    end
  end

  def decline
    @application = Application.find params[:id]
    authorize! :decline, @application

    if @application.decline
      respond_and_redirect_to @application.job_offer, t("applications.declined_successfully")
    else
      render_errors_and_action @application.job_offer
    end
  end

  private

    def rescue_from_exception(exception)
      if exception.subject.is_a?(Application)
        redirect_to exception.subject.job_offer, notice: exception.message
      else
        redirect_to @job_offer, notice: exception.message
      end
    end

    def application_params
      params.require(:application).permit(:job_offer_id)
    end

    def file_params
      params.require(:attached_files).permit([file_attributes: :file])
    end

    def check_attachment_is_valid
      if params[:attached_files]
        file = file_params[:file_attributes][0][:file]
        unless file.content_type == "application/pdf"
          job_offer = JobOffer.find application_params[:job_offer_id]
          flash[:error] = t("applications.choose_pdf")
          respond_and_redirect_to job_offer
        end
      end
    end
end
