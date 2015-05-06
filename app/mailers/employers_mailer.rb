class EmployersMailer < ActionMailer::Base
  default from: 'noreply-connect@hpi.de'

  def new_employer_email(employer)
    @employer = employer
    mail to: Configurable[:mailToAdministration], subject: t("employers_mailer.new_employer.subject")
  end

  def book_package_email(employer)
    @employer = employer
    mail to: Configurable[:mailToAdministration], subject: t("employers_mailer.book_package.subject")
  end

  def invite_colleague_email(employer, colleague_email, first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @employer = employer
    mail to: colleague_email, subject: t("employers_mailer.invite_colleague.subject")
  end

  def requested_package_confirmation_email(employer)
    @employer = employer
    mail to: @employer.staff_members.map(&:email), subject: t("employers_mailer.confirm_request.subject")
  end

  def booked_package_confirmation_email(employer)
    @employer = employer
    mail to: @employer.staff_members.map(&:email), subject: t("employers_mailer.confirm_booking.subject")
  end

  def registration_confirmation(employer)
    @employer = employer
    employer.staff_members.each do |staff|
      @staff = staff
      mail(to: staff.email, subject: t("employers_mailer.registration_confirmation.subject")).deliver
    end
  end
end
