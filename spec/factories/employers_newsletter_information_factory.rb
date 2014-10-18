# == Schema Information
#
# Table name: employers_newsletter_informations
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  employer_id :integer
#

FactoryGirl.define do 
	factory :employers_newsletter_information do
		association :student
		association :employer
	end
end
