# == Schema Information
#
# Table name: faqs
#
#  id         :integer          not null, primary key
#  question   :string(255)
#  answer     :text
#  created_at :datetime
#  updated_at :datetime
#  locale     :string(255)
#

require 'rails_helper'

describe Faq do
	before(:each) do
    	@faq = Faq.new("question" => "How do I make edits to my profile?", "answer" => "Log in to your account. Then hover over My Profile at the top right of the page. Choose the Edit-Button.", "locale" => "en")
	end

	describe "validation of parameters" do

		it "with question not present" do
			@faq.question = nil
			expect(@faq).to be_invalid
		end

		it "with answer not present" do
			@faq.answer = nil
			expect(@faq).to be_invalid
		end

		it "with all necessary parameters present" do
			expect(@faq).to be_valid
		end

	end
end
