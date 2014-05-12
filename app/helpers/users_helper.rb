module UsersHelper

  def user_is_staff_of_employer?(job_offer)
    signed_in? && current_user.staff? && current_user.manifestation.employer == job_offer.employer
  end

  def user_is_responsible_user?(job_offer)
    signed_in? && current_user.staff? && current_user.manifestation == job_offer.responsible_user
  end

  def update_and_remove_for_language(params, student_id, language_class, language_id_attribute)
    if params
      params.each do |id, skill|
        language = language_class.where(student_id: student_id, language_id_attribute.to_sym => id).first_or_create
        language.update_attributes(skill: skill)
      end

      remove_for_language(params, student_id, language_class, language_id_attribute)
    else
      language_class.destroy_all(student_id: student_id)
    end
  end

  def remove_for_language(params, student_id, language_class, language_id_attribute)
    language_class.where(student_id: student_id).each do |lang|
      if params[lang.attributes[language_id_attribute].to_s].nil?
        lang.destroy
      end
    end
  end

  def update_from_params_for_languages_and_newsletters(params, redirect_to) 
    update_and_remove_for_newsletter(params[:employers_newsletter_information], params[:id], EmployersNewsletterInformation, "employer_id")
    update_and_remove_for_newsletter(params[:programming_languages_newsletter_information], params[:id], ProgrammingLanguagesNewsletterInformation, "programming_language_id")
    update_from_params_for_languages(params, redirect_to)
  end


  def update_from_params_for_languages(params, redirect_to)
    update_and_remove_for_language(params[:programming_language_skills], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:language_skills], params[:id], LanguagesUser, "language_id")
  end

  def update_and_remove_for_newsletter(params, student_id, newsletter_class, attributes_id)
    if params
      params.each do |id, boolean|
        if boolean.to_i == 1
        newsletter_class.where(student_id: student_id, attributes_id.to_sym => id).first_or_create
       end
      end
       remove_for_newsletter(params, student_id, newsletter_class, attributes_id)
    else
      newsletter_class.destroy_all(student_id: student_id)
    end
  end

  def remove_for_newsletter(params, student_id, newsletter_class, attributes_id)
    newsletter_class.where(student_id: student_id).each do |n|
      if params[n.attributes[attributes_id].to_s].to_i == 0
        n.delete
      end
    end
  end
  
end
