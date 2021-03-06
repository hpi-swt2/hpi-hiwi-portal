# == Schema Information
#
# Table name: programming_languages_users
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  programming_language_id :integer
#  skill                   :integer
#

class ProgrammingLanguagesUser < ApplicationRecord
  belongs_to :student
  belongs_to :programming_language

  accepts_nested_attributes_for :programming_language

  before_destroy :destroy_programming_language, if: Proc.new { |this| this.programming_language.private? }

  def self.does_skill_exist_for_programming_language_and_student(programming_language, student)
    !find_by_student_id_and_programming_language_id(student.id,  programming_language.id).nil?
  end

  private

    def destroy_programming_language
      self.programming_language.destroy
    end
end
